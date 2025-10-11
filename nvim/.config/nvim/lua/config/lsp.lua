vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buffer = args.buf

    -- if client and client.server_capabilities.documentHighlightProvider then
    --   vim.api.nvim_create_autocmd('CursorHold', {
    --     callback = vim.lsp.buf.document_highlight,
    --   })
    --
    --   vim.api.nvim_create_autocmd('CursorMoved', {
    --     callback = vim.lsp.buf.clear_references,
    --   })
    -- end

    if client and client.server_capabilities.documentSymbolProvider then
      require('nvim-navbuddy').attach(client, buffer)
    end

    local opts = { buffer = buffer }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gk', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set('n', ']', function() vim.diagnostic.jump { count = 1, float = true } end, { buffer = buffer, nowait = true })
    vim.keymap.set('n', '[', function() vim.diagnostic.jump { count = -1, float = true } end, { buffer = buffer, nowait = true })
    vim.keymap.set('n', '>', '<CMD>cnext<CR>', opts)
    vim.keymap.set('n', '<', '<CMD>cprevious<CR>', opts)
    vim.keymap.set('n', '<leader>]', vim.diagnostic.setqflist, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
  end,
})

vim.diagnostic.config {
  virtual_text = true,
  severity_sort = true,
  update_in_insert = true,
}

vim.lsp.enable 'lua_ls'
vim.lsp.enable 'dart_ls'
vim.lsp.enable 'typescript'
