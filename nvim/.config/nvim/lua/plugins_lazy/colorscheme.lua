return {
	dir = '~/.config/theme1/',
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd 'set bg=light'
		require('theme1').setup()
	end,
}
