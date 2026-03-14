vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons.git' })
vim.pack.add({ 'https://github.com/sindrets/diffview.nvim.git' })

vim.keymap.set('n', '<leader>g', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview open' })

local ok, diffview = pcall(require, 'diffview')
if not ok then return end

diffview.setup {
  hooks = {
    diff_buf_read = function(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      local gitdir, relpath = name:match('^diffview://(.+%.git)/:%d+:/(.+)$')
      if gitdir and relpath then
        local toplevel = gitdir:gsub('/.git$', '')
        require('gitsigns').attach(bufnr, {
          file = toplevel .. '/' .. relpath,
          toplevel = toplevel,
          gitdir = gitdir,
        })
      end
    end,
  },
  keymaps = {
    disable_defaults = true,
    view = {
      { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      { 'n', '<tab>', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle files panel' } },
      { 'n', ']', ']c', { desc = 'Next hunk' } },
      { 'n', '[', '[c', { desc = 'Previous hunk' } },
      { 'n', 'r', '<cmd>Gitsigns reset_hunk<cr>', { desc = 'Reset hunk' } },
      { 'n', 'b', '<cmd>Gitsigns blame_line<cr>', { desc = 'Blame line' } },
    },
    file_panel = {
      { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      { 'n', '<tab>', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle files panel' } },
    },
  },
}
