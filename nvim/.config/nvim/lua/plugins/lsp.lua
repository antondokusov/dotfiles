local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buffer = args.buf

    lsp_highlight_document(client)
    if client.server_capabilities.documentSymbolProvider then require('nvim-navbuddy').attach(client, buffer) end

    local opts = { buffer = buffer }
    vim.keymap.set('n', 'gd', '<CMD>Glance definitions<CR>', opts)
    vim.keymap.set('n', 'gr', '<CMD>Glance references<CR>', opts)
    vim.keymap.set('n', 'gi', '<CMD>Glance implementations<CR>', opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>lK', vim.diagnostic.open_float, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>lf', '<cmd> lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<leader>lj', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>lk', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>ll', vim.lsp.codelens.run, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
  end,
})

local function setup()
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

return {
  {
    'folke/neodev.nvim',
    opts = {
      library = { plugins = { 'nvim-dap-ui', 'neotest' }, types = true },
    },
  },

  {
    'williamboman/mason.nvim',
    opts = {},
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {
      automatic_installation = true,
      ensure_installed = {
        'lua_ls',
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'SmiteshP/nvim-navbuddy',
    },
    init = setup,
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('lspconfig').lua_ls.setup {
        capabilities = capabilities,
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
          --[[ diagnostics.mypy, ]]
          diagnostics.clj_kondo,
          diagnostics.yamllint,
        },
      }
    end,
  },
}
