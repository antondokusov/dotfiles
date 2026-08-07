local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

local bufjump = require 'util.bufjump'
local fzf = require 'util.fzf'

keymap('n', 'sh', '<C-w>h', opts)
keymap('n', 'sj', '<C-w>j', opts)
keymap('n', 'sk', '<C-w>k', opts)
keymap('n', 'sl', '<C-w>l', opts)
keymap('n', 'ss', ':split<CR>', opts)
keymap('n', 'sv', ':vsplit<CR>', opts)
keymap('n', 'sp', '<cmd>q<CR>', opts)
keymap('n', 'Sh', '<C-w>H', opts)
keymap('n', 'Sj', '<C-w>J', opts)
keymap('n', 'Sk', '<C-w>K', opts)
keymap('n', 'Sl', '<C-w>L', opts)

keymap('n', '=', '<C-a>', opts)
keymap('n', '-', '<C-x>', opts)

keymap('n', '<C-a>', 'gg<S-v>G', opts)

keymap('n', '<C-Up>', ':resize -2<CR>', opts)
keymap('n', '<C-Down>', ':resize +2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

keymap('i', 'jk', '<ESC>', opts)

keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

keymap('x', 'J', ":move '>+0<CR>gv-gv", opts)
keymap('x', 'K', ":move '<-2<CR>gv-gv", opts)

keymap('v', 'p', '"_dP', opts)

keymap('v', '=', 'an', { remap = true, desc = 'Expand selection to outer node' })
keymap('v', '-', 'in', { remap = true, desc = 'Shrink selection to inner node' })

keymap('n', '<leader>u', '<CMD>Undotree<CR>', opts)

keymap('n', '<C-l>', bufjump.backward, opts)
keymap('n', '<C-k>', bufjump.forward, opts)

keymap('n', '<leader>f', fzf.find, opts)
keymap('n', '<leader>F', fzf.grep, opts)
keymap('v', '<leader>F', fzf.grep_visual, opts)
