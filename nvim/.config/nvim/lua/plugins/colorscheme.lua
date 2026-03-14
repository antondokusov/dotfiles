-- Bootstrap: symlink theme1 into pack/mine/start if not already present
local pack_path = vim.fn.stdpath('data') .. '/site/pack/mine/start/theme1'
if vim.fn.isdirectory(pack_path) == 0 then
  local theme_src = vim.fn.expand('~/.config/theme1')
  vim.fn.mkdir(vim.fn.fnamemodify(pack_path, ':h'), 'p')
  vim.uv.fs_symlink(theme_src, pack_path)
  vim.cmd.packadd('theme1')
end

vim.cmd 'set bg=light'
require('theme1').setup()
