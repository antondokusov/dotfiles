vim.pack.add({ 'https://github.com/OXY2DEV/markview.nvim.git' })

local ok, markview = pcall(require, 'markview')
if not ok then return end

markview.setup {
  preview = {
    modes = { "n", "no", "c", "v", "V" },
  },
  markdown = {
    headings = {
      heading_1 = { style = "icon", sign = false, icon = "󰼏  ", hl = "MarkviewHeading1Fg" },
      heading_2 = { style = "icon", sign = false, icon = "󰎨  ", hl = "MarkviewHeading2Fg" },
      heading_3 = { style = "icon", sign = false, icon = "󰼑  ", hl = "MarkviewHeading3Fg" },
      heading_4 = { style = "icon", sign = false, icon = "󰎲  ", hl = "MarkviewHeading4Fg" },
      heading_5 = { style = "icon", sign = false, icon = "󰼓  ", hl = "MarkviewHeading5Fg" },
      heading_6 = { style = "icon", sign = false, icon = "󰎴  ", hl = "MarkviewHeading6Fg" },
    },
  },
}
