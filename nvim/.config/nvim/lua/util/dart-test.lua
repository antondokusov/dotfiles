local M = {}

M.runDartTestUnderCursor = function()
  local lineNum = vim.api.nvim_win_get_cursor(0)[1]
  vim.cmd('!fvm flutter test "%?line=' .. lineNum .. '"')
end

M.runDartTestFile = function() vim.cmd '!fvm flutter test %' end

return M
