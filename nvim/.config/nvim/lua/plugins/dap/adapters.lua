local m = {}

m.python = {
	adapter = {
		type = 'executable',
		command = 'python3',
		args = { '-m', 'debugpy.adapter' },
	},
	configurations = {
		{
			type = 'python',
			request = 'launch',
			name = 'Launch file',
			program = '${file}',
		},
	},
}

-- https://github.com/flutter/flutter/blob/master/packages/flutter_tools/lib/src/debug_adapters/README.md#launchattach-arguments
m.dart = {
	adapter = {
		type = 'executable',
		command = '.fvm/flutter_sdk/bin/flutter',
		args = { 'debug_adapter' },
	},
	configurations = {
		{
			type = 'dart',
			request = 'launch',
			name = 'Launch dev',
			program = 'lib/main_development.dart',
			cwd = '${workspaceFolder}',
			toolArgs = { '--flavor', 'development', '-d', 'GM1900' },
			console = 'terminal',
		},
		{
			type = 'dart',
			request = 'launch',
			name = 'Launch prod',
			program = 'lib/main_production.dart',
			cwd = '${workspaceFolder}',
			toolArgs = { '--flavor', 'production' },
		},
		{
			type = 'dart',
			request = 'attach',
			name = 'Attach dev',
			program = 'lib/main_development.dart',
			cwd = '${workspaceFolder}',
		},
		{
			type = 'dart',
			request = 'attach',
			name = 'Attach production',
			program = 'lib/main_production.dart',
			cwd = '${workspaceFolder}',
		},
	},
}

return m
