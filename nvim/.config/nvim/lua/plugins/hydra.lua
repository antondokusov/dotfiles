return {
	{
		'anuvyklack/hydra.nvim',
		dependencies = {
			'mfussenegger/nvim-dap',
			'rcarriga/nvim-dap-ui',
		},
		config = function()
			local hydra = require 'hydra'
			local dap = require 'dap'

			local dap_hydra = hydra {
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

			local navigation_hydra_left = hydra {
				config = {
					color = 'pink',
					invoke_on_body = true,
				},
				name = 'navigation_left',
				mode = { 'n', 'x' },
				body = '<leader>a',
				heads = {
					{ 's', 'h', { silent = true, nowait = true } },
					{ 'g', 'l', { silent = true, nowait = true } },
					{ 'f', 'j', { silent = true } },
					{ 'd', 'k', { silent = true } },
					{ 'v', '<C-d>', { silent = true } },
					{ 'q', '<C-u>', { silent = true } },
					{ 'w', '<C-o>', { silent = true } },
					{ 'e', '<C-i>', { silent = true } },
					{ 'rq', '<CMD>Glance definitions<CR>', { silent = true } },
					{ 'rrq', '<CMD>Glance references<CR>', { silent = true } },
					{ 'z', nil, { exit = true, silent = true } },
				},
			}

			hydra.spawn = function(head)
				if head == 'dap-hydra' then dap_hydra:activate() end
				if head == 'navigation-hydra' then navigation_hydra:activate() end
				if head == 'navigation-hydra-left' then navigation_hydra_left:activate() end
			end

			vim.keymap.set('n', '<leader>d', "<cmd>lua require('hydra').spawn('dap-hydra')<cr>")
			vim.keymap.set('n', '<leader>j', "<cmd>lua require('hydra').spawn('navigation-hydra')<cr>")
			vim.keymap.set('n', '<leader>a', "<cmd>lua require('hydra').spawn('navigation-hydra-left')<cr>")
		end,
	},
}
