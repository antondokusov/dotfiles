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
  M._open_split(session)
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
  M._close_split(session)
end

-- Close every session that open() registered. Used from VimLeavePre, where
-- dap.sessions() may already be empty.
function M.close_all()
  for _, session in pairs(active) do
    M.close(session)
  end
end

-- Open a full-width horizontal split below that tails the session log file.
-- Does not take focus — reach it with the usual window motions. Uses tspin if available.
function M._open_split(session)
  local has_tspin = vim.fn.executable('tspin') == 1
  local path = vim.fn.shellescape(session._log_path)
  local pipeline = has_tspin
    and string.format('exec tail -F %s | tspin', path)
    or string.format('exec tail -F %s', path)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, { split = 'below', win = -1, height = 12 })

  -- win_call so the terminal attaches to this window's buffer, and picks up its
  -- dimensions for the pty, without moving the cursor out of the source buffer.
  session._log_job = vim.api.nvim_win_call(win, function()
    return vim.fn.jobstart({ 'bash', '-c', pipeline }, { term = true })
  end)
  session._log_win = win
  session._log_buf = buf
end

-- Tear down this session's log split. Idempotent.
-- The tail job is a child of nvim (jobs default to detach=false), so it also dies
-- on its own when nvim exits — this just handles the session-ended case promptly.
function M._close_split(session)
  if session._log_job then
    pcall(vim.fn.jobstop, session._log_job)
  end
  if session._log_win and vim.api.nvim_win_is_valid(session._log_win) then
    pcall(vim.api.nvim_win_close, session._log_win, true)
  end
  if session._log_buf and vim.api.nvim_buf_is_valid(session._log_buf) then
    pcall(vim.api.nvim_buf_delete, session._log_buf, { force = true })
  end
  session._log_job = nil
  session._log_win = nil
  session._log_buf = nil
end

return M
