require 'config.options'
require 'config.keymaps'
require 'config.plugins'
require 'config.lsp'

require 'plugins.nvim-dap'
require 'plugins.nvim-dap-view'

require('util.television').setup_ui_select()

require('util.flutter_util').start_daemon_and_poll_devices()
