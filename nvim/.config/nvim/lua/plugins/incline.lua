vim.pack.add({ 'https://github.com/b0o/incline.nvim.git' })

local ok, incline = pcall(require, 'incline')
if not ok then return end

incline.setup {
  hide = {
    only_win = true,
  },
  highlight = {
    groups = {
      InclineNormal = {
        default = true,
        group = 'Normal',
      },
      InclineNormalNC = {
        default = true,
        group = 'Normal',
      },
    },
  },
  window = {
    margin = {
      horizontal = 1,
      vertical = 1,
    },
  },
}
