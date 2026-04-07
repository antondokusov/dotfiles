local M = {}

local job_id = nil
local host = nil
local port = nil

local function reset()
  job_id = nil
  host = nil
  port = nil
end

-- Start DevTools server if not running, then call callback(host, port).
-- On failure, notifies and does not call callback.
function M.ensure_server(callback)
  if job_id then
    if host and port then
      callback(host, port)
    else
      vim.notify('DevTools: server starting, please wait...', vim.log.levels.INFO)
    end
    return
  end

  local buffer = ''

  job_id = vim.fn.jobstart({ 'fvm', 'dart', 'devtools', '--machine', '--no-launch-browser' }, {
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        if line == '' then goto continue end
        buffer = buffer .. line
        local ok, parsed = pcall(vim.fn.json_decode, buffer)
        if ok and parsed then
          buffer = ''
          if parsed.event == 'server.started' and parsed.params then
            host = parsed.params.host
            port = parsed.params.port
            vim.schedule(function() callback(host, port) end)
          end
        end
        ::continue::
      end
    end,
    on_stderr = function(_, data)
      for _, line in ipairs(data) do
        if line ~= '' then
          vim.schedule(function()
            vim.notify('DevTools: ' .. line, vim.log.levels.WARN)
          end)
        end
      end
    end,
    on_exit = function(_, exit_code)
      reset()
      if exit_code ~= 0 then
        vim.schedule(function()
          vim.notify('DevTools server exited with code: ' .. exit_code, vim.log.levels.WARN)
        end)
      end
    end,
    stdout_buffered = false,
    stderr_buffered = false,
  })

  if not job_id or job_id <= 0 then
    vim.notify('DevTools: failed to start server', vim.log.levels.ERROR)
    reset()
  end
end

-- Open DevTools in browser for the currently selected DAP session.
function M.open_for_session()
  local session = require('dap').session()
  if not session then
    vim.notify('DevTools: no active DAP session', vim.log.levels.WARN)
    return
  end

  local vm_service_uri = session.dart_vm_service_uri
  if not vm_service_uri then
    vim.notify('DevTools: VM service URI not available yet', vim.log.levels.WARN)
    return
  end

  M.ensure_server(function(h, p)
    local url = string.format('http://%s:%s/?uri=%s', h, p, vm_service_uri)
    vim.ui.open(url)
  end)
end

-- Stop the DevTools server if running.
function M.stop()
  if job_id then
    vim.fn.jobstop(job_id)
    reset()
  end
end

return M
