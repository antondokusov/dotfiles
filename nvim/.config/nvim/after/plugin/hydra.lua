local hydra = require 'hydra'
local dap = require 'dap'

local dap_hydra = hydra {
	-- hint = [[
	-- _n_: step over   _s_: Continue/Start   _b_: Breakpoint     _K_: Eval
	-- _i_: step into   _x_: Stop             ^ ^                 ^ ^
	-- _o_: step out    _R_: Hot restart      ^ ^
	-- _c_: to cursor   _r_: Hot reload
	-- ^
	-- ^ ^              _q_: exit
	--]],
	config = {
		color = 'pink',
		invoke_on_body = true,
		hint = {
			position = 'bottom',
			border = 'rounded',
		},
		on_enter = function() require('dapui').open {} end,
		on_exit = function() require('dapui').close {} end,
	},
	name = 'dap',
	mode = { 'n', 'x' },
	body = '<leader>d',
	heads = {
		{ 'n', dap.step_over, { silent = true } },
		{ 'i', dap.step_into, { silent = true } },
		{ 'o', dap.step_out, { silent = true } },
		{ 'c', dap.run_to_cursor, { silent = true } },
		{ 's', dap.continue, { silent = true } },
		{ 'x', dap.terminate, { silent = true } },
		--[[ { 'u', function() dap.set_exception_breakpoints { 'raised', 'uncaught' } end, { silent = true } }, ]]
		{ 'R', function() dap.session():request 'hotRestart' end, { silent = true } },
		{ 'r', function() dap.session():request 'hotReload' end, { silent = true } },
		{ 'b', dap.toggle_breakpoint, { silent = true } },
		{ 'K', ":lua require('dap.ui.widgets').hover()<CR>", { silent = true } },
		{ 'q', ':DapVirtualTextForceRefresh<CR>', { exit = true, nowait = true } },
	},
}

local navigation_hydra = hydra {
	config = {
		color = 'pink',
		invoke_on_body = true,
	},
	name = 'navigation',
	mode = { 'n', 'x' },
	body = '<leader>j',
	heads = {
		{ 'h', 'b', { silent = true } },
		{ 'l', 'w', { silent = true } },
		{ 'n', '<C-d>', { silent = true } },
		{ 'p', '<C-u>', { silent = true } },
		{ 'o', '<C-o>', { silent = true } },
		{ 'i', '<C-i>', { silent = true } },
		{ 'up', '<CMD>Glance definitions<CR>', { silent = true } },
		{ 'uup', '<CMD>Glance references<CR>', { silent = true } },
		{ '/', nil, { exit = true, silent = true } },
	},
}

local venn_hydra = hydra {
	name = 'Draw Diagram',
	hint = [[
 Arrow^^^^^^   Select region with <C-v>
 ^ ^ _K_ ^ ^   _f_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]],
	config = {
		color = 'pink',
		invoke_on_body = true,
		hint = {
			border = 'rounded',
		},
		on_enter = function() vim.o.virtualedit = 'all' end,
	},
	mode = 'n',
	body = '<leader>d',
	heads = {
		{ 'H', '<C-v>h:VBox<CR>' },
		{ 'J', '<C-v>j:VBox<CR>' },
		{ 'K', '<C-v>k:VBox<CR>' },
		{ 'L', '<C-v>l:VBox<CR>' },
		{ 'f', ':VBox<CR>', { mode = 'v' } },
		{ '<Esc>', nil, { exit = true } },
	},
}

hydra.spawn = function(head)
	if head == 'dap-hydra' then dap_hydra:activate() end
	if head == 'navigation-hydra' then navigation_hydra:activate() end
	if head == 'venn-hydra' then venn_hydra:activate() end
end
