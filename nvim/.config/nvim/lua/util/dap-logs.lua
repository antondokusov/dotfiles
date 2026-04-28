local M = {}

-- Sessions currently being logged. Tracked here (not via dap.sessions())
-- because nvim-dap clears its session table before VimLeavePre fires —
-- by the time our cleanup autocmd runs, dap.sessions() is already empty.
local active = {}

-- Derive a filesystem-safe slug from a DAP session.
-- 1. Drop ASCII parentheses
-- 2. Replace runs of non-alphanumeric chars with '_'
-- 3. Trim leading/trailing '_'
-- Falls back to session.config.type if the name is missing/empty.
function M._slug(session)
  local name = session and session.config and session.config.name
  if not name or name == '' then
    name = session and session.config and session.config.type or 'session'
  end
  local s = name:gsub('[()]', '')
  s = s:gsub('[^%w]+', '_')
  s = s:gsub('^_+', ''):gsub('_+$', '')
  if s == '' then s = 'session' end
  return s
end

-- Compute the absolute log file path for a session.
-- Format: ~/.cache/nvim/dap/<slug>__<YYYY-MM-DD_HH-MM-SS>.log
function M._resolve_path(session, now)
  local slug = M._slug(session)
  local ts = os.date('%Y-%m-%d_%H-%M-%S', now)
  local cache = vim.fn.stdpath('cache')
  return string.format('%s/dap/%s__%s.log', cache, slug, ts)
end

-- Open per-session log file. Idempotent: skips if already open.
-- Stores state on the session: _log_path, _log_file, _log_closed.
function M.open(session)
  if session._log_file or session._log_closed then return end
  local path = M._resolve_path(session)
  local dir = vim.fn.fnamemodify(path, ':h')
  if vim.fn.mkdir(dir, 'p') == 0 and vim.fn.isdirectory(dir) == 0 then
    vim.notify('DAP logs: cannot create ' .. dir, vim.log.levels.WARN)
    return
  end
  local f, err = io.open(path, 'a')
  if not f then
    vim.notify('DAP logs: cannot open ' .. path .. ': ' .. (err or '?'), vim.log.levels.WARN)
    return
  end
  f:setvbuf('line')
  session._log_path = path
  session._log_file = f
  session._log_closed = false
  active[session] = session
  M._spawn_pane(session)
end

-- Replacement for nvim-dap's default Session:event_output behavior.
-- Writes program output to the per-session log file. REPL gets nothing.
-- Telemetry events are dropped (matches nvim-dap default).
function M.on_output(session, body)
  if body.category == 'telemetry' then return end
  local f = session._log_file
  if f then f:write(body.output) end
end

-- Close the per-session log file. Idempotent.
function M.close(session)
  if session._log_closed then return end
  session._log_closed = true
  active[session] = nil
  local f = session._log_file
  if f then
    pcall(function() f:close() end)
    session._log_file = nil
  end
  M._kill_pane(session)
end

-- Close every session that open() registered. Used from VimLeavePre, where
-- dap.sessions() may already be empty.
function M.close_all()
  for _, session in pairs(active) do
    M.close(session)
  end
end

-- Spawn a Zellij pane that tails the session log file.
-- No-op when not running inside Zellij. Uses tspin if available.
-- Sets session._log_pane_spawned to true on successful dispatch.
function M._spawn_pane(session)
  if not vim.env.ZELLIJ or vim.env.ZELLIJ == '' then
    vim.notify('DAP logs: ' .. session._log_path .. ' (no Zellij — pane skipped)', vim.log.levels.INFO)
    return
  end
  local has_tspin = vim.fn.executable('tspin') == 1
  local pipeline = has_tspin
    and string.format("exec tail -F '%s' | tspin", session._log_path)
    or string.format("exec tail -F '%s'", session._log_path)
  local pane_name = 'DAP: ' .. M._slug(session)
  vim.system({ 'zellij', 'action', 'new-pane', '--name', pane_name, '--', 'bash', '-c', pipeline },
    { text = true },
    function(out)
      if out.code ~= 0 then
        vim.schedule(function()
          vim.notify('DAP logs: zellij new-pane failed (code ' .. out.code .. '): ' .. (out.stderr or ''), vim.log.levels.WARN)
        end)
      end
    end)
  session._log_pane_spawned = true
end

-- Kill the tail process for this session's log. Uses vim.fn.system (sync,
-- doesn't depend on the libuv loop) so cleanup still runs from VimLeavePre,
-- where libuv-based vim.system would not complete before nvim exits.
-- pkill is fast; the synchronous wait is imperceptible.
-- No notification on failure (most failures just mean the process already exited).
function M._kill_pane(session)
  if not session._log_pane_spawned or not session._log_path then return end
  local pattern = 'tail -F ' .. session._log_path
  vim.fn.system({ 'pkill', '-f', pattern })
end

return M
