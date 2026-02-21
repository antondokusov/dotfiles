local function list(items, sep) return table.concat(items, sep or ',') end

vim.g.mapleader = ' '

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
-- vim.opt.shellcmdflag = '-ci'

-- Automatically indents new lines to align with the previous line’s indentation level
vim.opt.autoindent = true

-- Sets the number of spaces used for each indentation level when using commands like >> or <<
vim.opt.shiftwidth = 2

-- Defines the width of a tab character in spaces when displayed.
vim.opt.tabstop = 2

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.cmdheight = 1
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.pumheight = 10
vim.opt.showmode = false
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.shortmess:append 'c'
vim.opt.laststatus = 3
-- vim.opt.statusline = "%#Normal#  %#StatusLine#%f %m%r%h%w %=%-14.(%l,%c%V%)%=%P%#Normal#"
vim.opt.smoothscroll = true -- todo
vim.opt.listchars = list {
  'tab: ──',
  'lead:·',
  'trail:•',
  'nbsp:␣',
  'precedes:«',
  'extends:»',
}
vim.opt.fillchars = list {
  'vert:│',
  'diff:╱',
  'foldclose:›',
  'foldopen:',
  'fold: ',
  'msgsep:─',
}

vim.o.diffopt = 'internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram'
vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldexpr = "v:lnum==1?'>1':getline(v:lnum)=~'import'?1:nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99

vim.opt.winborder = 'rounded'

vim.cmd 'set nomodeline'
