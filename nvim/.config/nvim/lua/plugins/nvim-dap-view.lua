vim.pack.add({ 'https://github.com/igorlfs/nvim-dap-view.git' })

-- Remap dap-view's buffer-local "s" (set value) to "v" so that
-- "s" prefix keymaps (sh/sj/sk/sl) for window navigation still work
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "dap-view://*",
  callback = function(args)
    local ok, existing = pcall(vim.fn.maparg, "s", "n", false, true)
    if ok and existing.buffer == 1 then
      pcall(vim.keymap.del, "n", "s", { buffer = args.buf })
      vim.keymap.set("n", "v", existing.callback or existing.rhs, { buffer = args.buf, nowait = true })
    end
  end,
})

require('dap-view').setup {
  winbar = {
    sections = { "repl", "watches", "sessions", "scopes", "exceptions", "breakpoints", "threads" },
    default_section = "repl",
  },
}
