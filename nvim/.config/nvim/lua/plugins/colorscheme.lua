return {
	'rose-pine/neovim',
	lazy = false,
	priority = 1000,
	config = function()
    vim.cmd 'set bg=light'

		require('rose-pine').setup {
			variant = 'dawn',
			-- disable_background = true,
			disable_float_background = true,
		}

		vim.cmd 'colorscheme rose-pine-dawn'
	end,
}
