vim.pack.add({ 'https://github.com/igorlfs/nvim-dap-view.git' })

-- Delete dap-view's buffer-local "s" (set value) so that
-- "s" prefix keymaps (sh/sj/sk/sl) for window navigation still work
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "dap-view://*",
  callback = function(args)
    pcall(vim.keymap.del, "n", "s", { buffer = args.buf })
  end,
})

require('dap-view').setup {
  winbar = {
    sections = { "repl", "watches", "sessions", "scopes", "exceptions", "breakpoints", "threads" },
    default_section = "repl",
  },
}

-- dap-view ignores dap.defaults.*.exception_breakpoints and reads the
-- adapter's filter.default instead. Use vim.schedule in configurationDone
-- to run after all synchronous listeners (including dap-view's) have
-- fired, then override both the state and the adapter.
require('dap').listeners.after.configurationDone['disable-exception-defaults'] = function(session)
  vim.schedule(function()
    local state = require('dap-view.state')
    local opts = state.exceptions_options[session.config.type]
    if opts then
      for _, opt in ipairs(opts) do
        opt.enabled = false
      end
    end
    session:set_exception_breakpoints({})
  end)
end
