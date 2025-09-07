local opts = { noremap = true, silent = true }

local keymap = vim.keymap.set

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

keymap('n', '<C-l>', ':bp<CR>', opts)
keymap('n', '<C-k>', ':bn<CR>', opts)
