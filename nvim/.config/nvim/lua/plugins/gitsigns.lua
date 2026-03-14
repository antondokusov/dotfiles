vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim.git' })

local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then return end

gitsigns.setup {
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '' },
    topdelete = { text = '' },
    changedelete = { text = '▎' },
  },
}

vim.keymap.set('n', '}', gitsigns.next_hunk)
vim.keymap.set('n', '{', gitsigns.prev_hunk)
