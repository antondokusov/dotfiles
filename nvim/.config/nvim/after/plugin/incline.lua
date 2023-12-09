require('incline').setup {
	hide = {
		only_win = true, -- Hide incline if only one window in tab
	},
	highlight = {
		groups = {
			InclineNormal = {
				default = true,
				group = 'Normal',
			},
			InclineNormalNC = {
				default = true,
				group = 'Normal',
			},
		},
	},
	window = {
		margin = {
			horizontal = 1,
			vertical = 1,
		},
	},
}
