local dap = require 'dap'
local config = require 'plugins.dap.adapters'

dap.adapters.python = config.python.adapter
dap.configurations.python = config.python.configurations

dap.adapters.dart = config.dart.adapter
dap.configurations.dart = config.dart.configurations

dap.defaults.dart.exception_breakpoints = { 'raised' }

dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.external_terminal = {
	command = '/opt/homebrew/bin/kitty',
	args = { '--hold' },
}

require('dapui').setup {
	controls = { enabled = false },
	layouts = {
		{
			elements = {
				'repl',
			},
			size = 10,
			position = 'bottom', -- Can be "bottom" or "top"
		},
		{
			-- You can change the order of elements in the sidebar
			elements = {
				-- Provide IDs as strings or tables with "id" and "size" keys
				{
					id = 'scopes',
					size = 0.3, -- Can be float or integer > 1
				},
				{ id = 'breakpoints', size = 0.3 },
				{ id = 'stacks', size = 0.3 },
			},
			size = 40,
			position = 'left', -- Can be "left" or "right"
		},
	},
}

require('nvim-dap-virtual-text').setup {}
