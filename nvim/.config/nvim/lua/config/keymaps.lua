local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

local bufjump = require 'util.bufjump'
local television = require 'util.television'
local dart_test = require 'util.dart-test'

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

keymap('n', '<C-l>', bufjump.backward, opts)
keymap('n', '<C-k>', bufjump.forward, opts)

keymap('n', '<leader>t', dart_test.runDartTestUnderCursor, opts)
keymap('n', '<leader>tt', dart_test.runDartTestFile, opts)

keymap('n', '<leader>f', television.find, opts)

local session_keys = require('util.session-keys')

session_keys.sessions.dap = {
  n = {
    { lhs = 'n', rhs = function() require('dap').step_over() end, opts = { desc = 'Step over' } },
    { lhs = 'i', rhs = function() require('dap').step_into() end, opts = { desc = 'Step into' } },
    { lhs = 'o', rhs = function() require('dap').step_out() end, opts = { desc = 'Step out' } },
    { lhs = 'c', rhs = function() require('dap').continue() end, opts = { desc = 'Continue' } },
    { lhs = 'R', rhs = function() require('dap').session():request('hotRestart') end, opts = { desc = 'Hot restart' } },
    { lhs = 'r', rhs = function() require('dap').session():request('hotReload') end, opts = { desc = 'Hot reload' } },
    { lhs = 'b', rhs = function() require('dap').toggle_breakpoint() end, opts = { desc = 'Toggle breakpoint' } },
    { lhs = 'w', rhs = function() require('dap-view').add_expr() end, opts = { desc = 'Add watch expr' } },
    { lhs = '.', rhs = function() require('dap-view').navigate({ count = 1, wrap = true }) end, opts = { desc = 'Next view' } },
    { lhs = ',', rhs = function() require('dap-view').navigate({ count = -1, wrap = true }) end, opts = { desc = 'Prev view' } },
    { lhs = 'd', rhs = function() require('util.flutter_util').select_flutter_device() end, opts = { desc = 'Select device' } },
    { lhs = 'q', rhs = function()
      require('util.session-keys'):stop('dap')
      require('dap-view').close()
    end, opts = { desc = 'Quit DAP mode' } },
  },
}

keymap('n', '<leader>d', function()
  require('util.session-keys'):start('dap')
  require('dap-view').open()
end, opts)
