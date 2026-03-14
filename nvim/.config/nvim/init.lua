require 'config.options'
require 'config.keymaps'
require 'config.lsp'

require 'plugins.colorscheme'
require 'plugins.treesitter'
require 'plugins.sidekick'
require 'plugins.navbuddy'
require 'plugins.autopairs'
require 'plugins.gitsigns'
require 'plugins.mini-files'
require 'plugins.incline'
require 'plugins.diffview'
require 'plugins.nvim-dap'
require 'plugins.nvim-dap-view'

require('util.fzf').setup_ui_select()

require('util.flutter_util').start_daemon_and_poll_devices()
