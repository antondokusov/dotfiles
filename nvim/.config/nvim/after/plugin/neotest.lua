require('neotest').setup {
	adapters = {
		require 'neotest-dart' {
			command = 'fvm flutter',
			use_lsp = true,
		},
	},
}
