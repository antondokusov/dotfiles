local opts = { noremap = true, silent = true }

local keymap = vim.keymap.set

 -- https://github.com/kwkarlwang/bufjump.nvim
local jumpbackward = function(num)
  vim.cmd([[execute "normal! ]] .. tostring(num) .. [[\<c-o>"]])
end

local jumpforward = function(num)
  vim.cmd([[execute "normal! ]] .. tostring(num) .. [[\<c-i>"]])
end

local backward = function()
  local getjumplist = vim.fn.getjumplist()
  local jumplist = getjumplist[1]
  if #jumplist == 0 then
    return
  end

  -- plus one because of one index
  local i = getjumplist[2] + 1
  local j = i
  local curBufNum = vim.fn.bufnr()
  local targetBufNum = curBufNum

  while j > 1 and (curBufNum == targetBufNum or not vim.api.nvim_buf_is_valid(targetBufNum)) do
    j = j - 1
    targetBufNum = jumplist[j].bufnr
  end
  if targetBufNum ~= curBufNum and vim.api.nvim_buf_is_valid(targetBufNum) then
    jumpbackward(i - j)
  end
end

local forward = function()
  local getjumplist = vim.fn.getjumplist()
  local jumplist = getjumplist[1]
  if #jumplist == 0 then
    return
  end

  local i = getjumplist[2] + 1
  local j = i
  local curBufNum = vim.fn.bufnr()
  local targetBufNum = curBufNum

  -- find the next different buffer
  while j < #jumplist and (curBufNum == targetBufNum or vim.api.nvim_buf_is_valid(targetBufNum) == false) do
    j = j + 1
    targetBufNum = jumplist[j].bufnr
  end
  while j + 1 <= #jumplist and jumplist[j + 1].bufnr == targetBufNum and vim.api.nvim_buf_is_valid(targetBufNum) do
    j = j + 1
  end
  if j <= #jumplist and targetBufNum ~= curBufNum and vim.api.nvim_buf_is_valid(targetBufNum) then
    jumpforward(j - i)
  end
end

keymap('n', 'sh', '<C-w>h', opts)
keymap('n', 'sj', '<C-w>j', opts)
keymap('n', 'sk', '<C-w>k', opts)
keymap('n', 'sl', '<C-w>l', opts)
keymap('n', 'ss', ':split<CR>', opts)
keymap('n', 'sv', ':vsplit<CR>', opts)
keymap('n', 'sp', '<cmd>q<CR>', opts)
keymap('n', 'Sh', '<C-w>H', opts)
keymap('n', 'Sj', '<C-w>J', opts)
keymap('n', 'Sk', '<C-w>K', opts)
keymap('n', 'Sl', '<C-w>L', opts)

keymap('n', '=', '<C-a>', opts)
keymap('n', '-', '<C-x>', opts)

keymap('n', '<C-a>', 'gg<S-v>G', opts)

keymap('n', '<C-Up>', ':resize -2<CR>', opts)
keymap('n', '<C-Down>', ':resize +2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

keymap('i', 'jk', '<ESC>', opts)

keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

keymap('x', 'J', ":move '>+0<CR>gv-gv", opts)
keymap('x', 'K', ":move '<-2<CR>gv-gv", opts)

keymap('v', 'p', '"_dP', opts)

keymap('n', '<C-l>', backward, opts)
keymap('n', '<C-k>', forward, opts)
