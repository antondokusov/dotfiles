-- https://github.com/flutter/flutter/blob/master/packages/flutter_tools/doc/daemon.md

local M = {}

-- Module state
local daemon_job_id = nil
local request_id = 0
local pending_requests = {}
local event_handlers = {}

-- Helper function to parse JSON
local function parse_json(str)
	local ok, result = pcall(vim.fn.json_decode, str)
	if ok then
		return result
	end
	return nil
end

-- Helper function to encode JSON
local function encode_json(obj)
	local ok, result = pcall(vim.fn.json_encode, obj)
	if ok then
		return result
	end
	return nil
end

-- Process a line from daemon output
local function process_daemon_output(line)
	-- Remove square brackets wrapper
	if line:match("^%[.*%]$") then
		line = line:sub(2, -2)
	end

	local data = parse_json(line)
	if not data then
		return
	end

	-- Check if it's a response to a request
	if data.id ~= nil and pending_requests[data.id] then
		local callback = pending_requests[data.id]
		pending_requests[data.id] = nil
		if callback then
			callback(data.result, data.error)
		end
	end

	-- Check if it's an event
	if data.event then
		local handlers = event_handlers[data.event] or {}
		for _, handler in ipairs(handlers) do
			handler(data.params)
		end
	end
end

-- Start the Flutter daemon
function M.start()
	if daemon_job_id then
		return true
	end

	daemon_job_id = vim.fn.jobstart({ "flutter", "daemon" }, {
		on_stdout = function(_, data, _)
			for _, line in ipairs(data) do
				if line ~= "" then
					process_daemon_output(line)
				end
			end
		end,
		on_stderr = function(_, data, _)
			for _, line in ipairs(data) do
				if line ~= "" then
					vim.notify("Flutter daemon error: " .. line, vim.log.levels.ERROR)
				end
			end
		end,
		on_exit = function(_, exit_code, _)
			daemon_job_id = nil
			pending_requests = {}
			if exit_code ~= 0 then
				vim.notify("Flutter daemon exited with code: " .. exit_code, vim.log.levels.WARN)
			end
		end,
		stdout_buffered = false,
		stderr_buffered = false,
	})

	return daemon_job_id > 0
end

-- Stop the Flutter daemon
function M.stop()
	if daemon_job_id then
		vim.fn.jobstop(daemon_job_id)
		daemon_job_id = nil
		pending_requests = {}
	end
end

-- Check if daemon is running
function M.is_running()
	return daemon_job_id ~= nil
end

-- Send a command to the daemon
-- @param method: string - The method name (e.g., "daemon.version", "device.getDevices")
-- @param params: table|nil - Optional parameters for the method
-- @param callback: function|nil - Optional callback function(result, error)
function M.send_command(method, params, callback)
	if not daemon_job_id then
		if callback then
			callback(nil, "Daemon not running")
		end
		return nil
	end

	request_id = request_id + 1
	local id = request_id

	local command = {
		id = id,
		method = method,
	}

	if params then
		command.params = params
	end

	local json = encode_json({ command })
	if not json then
		if callback then
			callback(nil, "Failed to encode JSON")
		end
		return nil
	end

	-- Store the callback
	if callback then
		pending_requests[id] = callback
	end

	-- Send the command
	vim.fn.chansend(daemon_job_id, json .. "\n")

	return id
end

-- Send a command and wait for the result synchronously
-- @param method: string - The method name
-- @param params: table|nil - Optional parameters
-- @param timeout: number|nil - Timeout in milliseconds (default: 5000)
-- @return result: table|nil, error: string|nil
function M.call(method, params, timeout)
	timeout = timeout or 5000
	local result = nil
	local error = nil
	local done = false

	M.send_command(method, params, function(res, err)
		result = res
		error = err
		done = true
	end)

	-- Wait for response
	local start_time = vim.loop.hrtime()
	while not done do
		if (vim.loop.hrtime() - start_time) / 1000000 > timeout then
			return nil, "Timeout"
		end
		vim.wait(10)
	end

	return result, error
end

-- Register an event handler
-- @param event: string - The event name (e.g., "daemon.connected", "device.added")
-- @param handler: function - The handler function(params)
function M.on(event, handler)
	if not event_handlers[event] then
		event_handlers[event] = {}
	end
	table.insert(event_handlers[event], handler)
end

-- Remove an event handler
function M.off(event, handler)
	if not event_handlers[event] then
		return
	end
	for i, h in ipairs(event_handlers[event]) do
		if h == handler then
			table.remove(event_handlers[event], i)
			break
		end
	end
end

return M
