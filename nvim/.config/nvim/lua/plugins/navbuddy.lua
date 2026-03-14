vim.pack.add({ 'https://github.com/SmiteshP/nvim-navic.git' })
vim.pack.add({ 'https://github.com/MunifTanjim/nui.nvim.git' })
vim.pack.add({ 'https://github.com/SmiteshP/nvim-navbuddy.git' })

local ok, navbuddy = pcall(require, 'nvim-navbuddy')
if not ok then return end

vim.keymap.set('n', '<leader>ls', navbuddy.open)
