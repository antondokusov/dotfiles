return {
	'rose-pine/neovim',
	dir = '~/Documents/rose-pine/',
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd 'set bg=light'

		require('rose-pine').setup {
			variant = 'dawn',
			disable_float_background = true,
		}
	end,
}
