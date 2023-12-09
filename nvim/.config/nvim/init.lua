require 'config.options'
require 'config.keymaps'
require 'config.plugins'
--require 'config.plugins-lazy'
require 'plugins.lsp'
require 'plugins.dap'

require('rose-pine').setup {
	disable_background = true,
	disable_float_background = true,
}

vim.cmd 'colorscheme rose-pine-moon'
