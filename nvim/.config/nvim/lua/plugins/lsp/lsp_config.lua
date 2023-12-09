require('mason').setup {}
require('mason-lspconfig').setup {
	automatic_installation = true,
	ensure_installed = {
		'lua_ls',
		'clojure_lsp', --[[ 'jsonls', ]]
		'pyright',
	},
}

require('neodev').setup {
	library = { plugins = { 'nvim-dap-ui', 'neotest' }, types = true },
}

require('mason-lspconfig').setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			on_attach = require('plugins.lsp.handlers').on_attach,
			capabilities = require('plugins.lsp.handlers').capabilities,
		}
	end,
}

require('lspconfig').lua_ls.setup {
	on_attach = require('plugins.lsp.handlers').on_attach,
	capabilities = require('plugins.lsp.handlers').capabilities,
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				checkThirdParty = false,
			},
			completion = {
				callSnippet = 'Replace',
			},
		},
	},
}

require('lspconfig').dartls.setup {
	on_attach = require('plugins.lsp.handlers').on_attach,
	capabilities = require('plugins.lsp.handlers').capabilities,
	cmd = { 'fvm', 'dart', 'language-server', '--protocol=lsp' },
	init_options = {
		closingLabels = false,
		outline = false,
		flutterOutline = false,
	},
	settings = {
		dart = {
			lineLength = 120,
			showTodos = false,
			analysisExcludedFolders = {
				vim.fn.expand '$HOME/.pub-cache',
				vim.fn.expand '$HOME/fvm/',
			},
		},
	},
}
