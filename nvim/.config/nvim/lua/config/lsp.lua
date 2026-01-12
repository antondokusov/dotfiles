vim.lsp.enable { 'copilot', 'lua_ls', 'typescript', 'dart_ls', 'nushell' }

vim.diagnostic.config {
  virtual_text = true,
  severity_sort = true,
  update_in_insert = true,
}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local clientId = args.data.client_id
    local client = vim.lsp.get_client_by_id(clientId)
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

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
      require('nvim-navbuddy').attach(client, buffer)
    end

    ---Is the completion menu open?
    local function pumvisible()
      return tonumber(vim.fn.pumvisible()) ~= 0
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion) then
      vim.lsp.inline_completion.enable(true)
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'nosort', 'popup' }
      vim.lsp.completion.enable(true, client.id, buffer, { autotrigger = false })

      vim.keymap.set('i', '<C-n>', function()
        if next(vim.lsp.get_clients { bufnr = 0 }) then
          vim.lsp.completion.get()
        else
          return '<C-n>'
        end
      end, { expr = true })
    end

    vim.keymap.set('i', '<C-p>', '<C-x><C-n>', { desc = 'Buffer completions' })

    vim.keymap.set({ 'i', 'n' }, '<Tab>', function()
      local nes = require 'sidekick'

      if nes.nes_jump_or_apply() then
        return ''
      elseif vim.lsp.inline_completion.get() then
        return ''
      elseif pumvisible() then
        return '<C-y>'
      else
        return '<Tab>'
      end
    end, { expr = true, silent = true })

    local opts = { buffer = buffer }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gk', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set('n', ']', function() vim.diagnostic.jump { count = 1, float = true } end,
      { buffer = buffer, nowait = true })
    vim.keymap.set('n', '[', function() vim.diagnostic.jump { count = -1, float = true } end,
      { buffer = buffer, nowait = true })
    vim.keymap.set('n', '>', '<CMD>cnext<CR>', opts)
    vim.keymap.set('n', '<', '<CMD>cprevious<CR>', opts)
    vim.keymap.set('n', '<leader>[', vim.diagnostic.setqflist, opts)
    vim.keymap.set('n', '<leader>]', function() vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR } end,
      opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
  end,
})
