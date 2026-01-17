return {
  cmd = { 'fvm', 'dart', 'language-server', '--protocol=lsp', '--port=8123' },
  filetypes = { 'dart' },
  root_markers = { 'pubspec.yaml', '.git' },
  init_options = {
    closingLabels = false,
    outline = false,
    flutterOutline = false,
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
  end,
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
