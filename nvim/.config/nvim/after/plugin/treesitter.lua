require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
	},
	autopairs = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<CR>',
			scope_incremental = '<CR>',
			node_incremental = '<TAB>',
			node_decremental = '<S-TAB>',
		},
	},
}

require('treesitter-context').setup {
	--[[ enable = false, ]]
}
