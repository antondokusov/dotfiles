vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter.git' })
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git' })

local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then return end

configs.setup {
  highlight = {
    enable = true,
  },
}
