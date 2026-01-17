require 'config.options'
require 'config.keymaps'
require 'config.plugins'
require 'config.lsp'

require 'plugins.nvim-dap-view'

require('config.util').setup_ui_select()

require('config.flutter_device').start_daemon_and_poll_devices()
