local mode_map = {
  n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
  ["\22"] = "V-BLOCK", c = "COMMAND", R = "REPLACE", t = "TERMINAL",
  s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK",
}

function Statusline()
  local parts = {}

  -- Mode
  local mode = mode_map[vim.fn.mode()] or vim.fn.mode():upper()
  table.insert(parts, "%#StatusLine# " .. mode)

  -- Branch (from gitsigns)
  local branch = vim.b.gitsigns_head
  if branch and branch ~= "" then
    table.insert(parts, "  " .. branch)
  end

  -- Diagnostics (workspace-wide)
  local counts = vim.diagnostic.count() or {}
  local e = counts[vim.diagnostic.severity.ERROR] or 0
  local w = counts[vim.diagnostic.severity.WARN] or 0
  local i = counts[vim.diagnostic.severity.INFO] or 0
  local h = counts[vim.diagnostic.severity.HINT] or 0
  local diag = {}
  if e > 0 then table.insert(diag, "%#DiagnosticError#" .. e) end
  if w > 0 then table.insert(diag, "%#DiagnosticWarn#" .. w) end
  if i > 0 then table.insert(diag, "%#DiagnosticHint#" .. i) end
  if h > 0 then table.insert(diag, "%#DiagnosticHint#" .. h) end
  if #diag > 0 then table.insert(parts, "  " .. table.concat(diag, " ")) end

  -- Filename
  table.insert(parts, "  %#StatusLine#%f %m")

  -- Right side: percentage
  table.insert(parts, "%=")
  table.insert(parts, "%p%% ")

  return table.concat(parts)
end

vim.opt.statusline = "%!v:lua.Statusline()"
