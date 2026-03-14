vim.pack.add({ 'https://github.com/folke/sidekick.nvim.git' })

local ok, sidekick = pcall(require, 'sidekick')
if not ok then return end

sidekick.setup {
  nes = {
    enabled = true,
    diff = {
      inline = 'chars',
    },
  },
  cli = {
    mux = {
      backend = 'zellij',
      enabled = true,
    },
  },
}
