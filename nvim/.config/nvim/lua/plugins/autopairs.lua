vim.pack.add({ 'https://github.com/windwp/nvim-autopairs.git' })

local ok, autopairs = pcall(require, 'nvim-autopairs')
if not ok then return end

autopairs.setup {}
