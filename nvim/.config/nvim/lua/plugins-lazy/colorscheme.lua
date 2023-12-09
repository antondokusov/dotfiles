return {
	'rose-pine/neovim',
	lazy = false,
  priority = 1000,
	opts = {
		disable_background = true,
		disable_float_background = true,
	},
	config = function() vim.cmd 'colorscheme rose-pine-moon' end,
}
