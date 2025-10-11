return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { {'.luarc.json', '.luarc.jsonc'}, '.stylua.toml', '.git' },
  settings = {
    Lua = {
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
