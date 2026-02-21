local config = {}

config.options = {
	variant = "dawn",

	extend_background_behind_borders = true,

	enable = {
		terminal = true,
	},

	styles = {
		bold = true,
	},

	groups = {
		border = "muted",
		panel = "surface",

		error = "love",
		hint = "iris",
		info = "foam",
		ok = "leaf",
		warn = "gold",

		git_add = "diff_add",
		git_change = "diff_change",
		git_delete = "diff_delete",
		git_text = "rose",
	},

	highlight_groups = {},
}

function config.extend_options(options)
	config.options = vim.tbl_deep_extend("force", config.options, options or {})
end

return config
