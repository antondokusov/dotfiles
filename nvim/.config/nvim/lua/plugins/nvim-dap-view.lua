vim.pack.add({ 'https://github.com/igorlfs/nvim-dap-view.git' })

require('dap-view').setup {
  winbar = {
    sections = { "repl", "watches", "sessions", "scopes", "exceptions", "breakpoints", "threads" },
    default_section = "repl",
  },
}
