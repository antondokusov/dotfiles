vim.pack.add({ 'https://github.com/echasnovski/mini.files.git' })

local ok, mini_files = pcall(require, 'mini.files')
if not ok then return end

mini_files.setup {}

vim.keymap.set('n', '<leader>e', function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
end, { desc = 'File explorer' })
