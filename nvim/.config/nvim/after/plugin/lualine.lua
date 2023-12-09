local hydra = require 'hydra.statusline'

---@diagnostic disable-next-line: unused-local
local vim_mode = {
	'mode',
	cond = function() return not hydra.is_active() end,
}

---@diagnostic disable-next-line: unused-local
local hydra_mode = {
	hydra.get_name,
	cond = function() return hydra.is_active() end,
	color = function() return { fg = 'black', bg = hydra.get_color() } end,
}

require('lualine').setup {
	options = {
		disabled_filetypes = { 'NvimTree' },
		component_separators = '|',
		section_separators = { left = '', right = '' },
	},
	tabline = {},
	sections = {
		lualine_a = {
			{ 'mode', separator = { left = '  ', right = '' } },
		},
		lualine_b = {
			'branch',
			{ 'diagnostics', sources = { 'nvim_workspace_diagnostic' } },
		},
		lualine_c = { { 'filename', path = 1 } },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {
			{ 'location', separator = { left = '', right = '  ' } },
		},
	},
}
