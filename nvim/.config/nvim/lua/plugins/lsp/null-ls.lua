local null_ls = require 'null-ls'

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
	sources = {
		formatting.stylua,
		formatting.black.with { extra_args = { '--fast', '--line-length', '120' } },
		formatting.prettier,
		diagnostics.flake8.with { extra_args = { '--max-line-length', '120' } },
		--[[ diagnostics.mypy, ]]
		diagnostics.clj_kondo,
		diagnostics.yamllint,
	},
}
