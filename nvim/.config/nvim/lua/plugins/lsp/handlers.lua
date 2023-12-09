local m = {}

m.setup = function()
	local signs = {
		{ name = 'DiagnosticSignError', text = '' },
		{ name = 'DiagnosticSignHint', text = '' },
		{ name = 'DiagnosticSignWarn', text = '' },
		{ name = 'DiagnosticSignInfo', text = '' },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
	end

	local config = {
		virtual_text = true,
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = 'minimal',
			border = 'rounded',
			source = 'always',
			header = '',
			prefix = '',
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = 'rounded',
	})

	vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = 'rounded',
	})
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then vim.api.nvim_exec(
		[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
		false
	) end
end

local function lsp_keymaps(bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set('n', 'gd', '<CMD>Glance definitions<CR>', opts)
	vim.keymap.set('n', 'gr', '<CMD>Glance references<CR>', opts)
	vim.keymap.set('n', 'gi', '<CMD>Glance implementations<CR>', opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<leader>lK', vim.diagnostic.open_float, opts)
	vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)

	vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

local navbuddy = require 'nvim-navbuddy'
m.on_attach = function(client, bufnr)
	navbuddy.attach(client, bufnr)
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

m.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

return m
