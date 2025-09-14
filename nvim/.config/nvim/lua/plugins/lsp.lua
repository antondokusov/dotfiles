vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buffer = args.buf

    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd('CursorHold', {
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd('CursorMoved', {
        callback = vim.lsp.buf.clear_references,
      })
    end

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
    vim.keymap.set('n', ']', function() vim.diagnostic.jump { count = 1, float = false } end, { buffer = buffer, nowait = true })
    vim.keymap.set('n', '[', function() vim.diagnostic.jump { count = -1, float = false } end, { buffer = buffer, nowait = true })
    vim.keymap.set('n', '>', '<CMD>cnext<CR>', opts)
    vim.keymap.set('n', '<', '<CMD>cprevious<CR>', opts)
    vim.keymap.set('n', '<leader>]', vim.diagnostic.setqflist, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
  end,
})

vim.diagnostic.config {
  virtual_lines = {
    current_line = true,
  },
}

return {

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'SmiteshP/nvim-navbuddy',
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('lspconfig').lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            format = {
              enable = false,
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              checkThirdParty = false,
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('lua', true),
            },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      }

      require('lspconfig').sourcekit.setup {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      }

      require('lspconfig').ruff.setup {
        init_options = {
          settings = {
            showSyntaxErrors = false,
            lint = {
              enable = false,
            },
          },
        },
      }

      require('lspconfig').pyright.setup {}

      require('lspconfig').dartls.setup {
        capabilities = capabilities,
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
    end,
  },

  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local null_ls = require 'null-ls'

      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      null_ls.setup {
        sources = {
          formatting.stylua,
          formatting.prettier,
          formatting.shfmt,
          diagnostics.clj_kondo,
          diagnostics.yamllint,
        },
      }
    end,
  },
}
