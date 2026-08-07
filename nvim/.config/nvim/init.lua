require 'config.options'
require 'config.keymaps'
require 'config.lsp'

vim.cmd.packadd 'nvim.undotree'

require 'plugins.colorscheme'
require 'plugins.autopairs'
require 'plugins.gitsigns'
require 'plugins.mini-files'

require('util.fzf').setup_ui_select()
