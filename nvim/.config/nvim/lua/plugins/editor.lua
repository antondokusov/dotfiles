return {
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		config = function()
			require('ts_context_commentstring').setup {
				enable_autocmd = false,
			}
		end,
	},

	{
		'nvim-treesitter/nvim-treesitter-context',
		opts = {},
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = '<CR>',
						scope_incremental = '<CR>',
						node_incremental = '<TAB>',
						node_decremental = '<S-TAB>',
					},
				},
			}
		end,
	},

	{
		'numToStr/Comment.nvim',
		dependencies = {
			'JoosepAlviste/nvim-ts-context-commentstring',
		},
		config = function()
			require('Comment').setup {
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
			}
		end,
	},

	{
		'ibhagwan/fzf-lua',
		config = function()
			local fzf = require 'fzf-lua'

			fzf.setup {
				winopts = {
					preview = {
						layout = 'vertical',
					},
				},
			}

			vim.keymap.set('n', '<leader>f', fzf.files)
			vim.keymap.set('n', '<leader>F', fzf.grep)
			vim.keymap.set('n', '<leader>la', fzf.lsp_code_actions)
			vim.keymap.set('n', '<leader>lQ', fzf.lsp_workspace_diagnostics)
		end,
	},

	{
		'SmiteshP/nvim-navbuddy',
		dependencies = {
			'neovim/nvim-lspconfig',
			'SmiteshP/nvim-navic',
			'MunifTanjim/nui.nvim',
		},
		config = function() vim.keymap.set('n', '<leader>ls', require('nvim-navbuddy').open) end,
	},

	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = {
			disable_filetype = { 'TelescopePrompt' },
		},
	},

	{
		'lewis6991/gitsigns.nvim',
		config = function()
			local gitsigns = require 'gitsigns'
			gitsigns.setup {

				signs = {
					add = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
					change = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
					delete = { hl = 'GitSignsDelete', text = '', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
					topdelete = { hl = 'GitSignsDelete', text = '', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
					changedelete = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
				},
				current_line_blame_formatter_opts = {
					relative_time = false,
				},
			}

			vim.keymap.set('n', '<leader>gj', gitsigns.next_hunk)
			vim.keymap.set('n', '<leader>gk', gitsigns.prev_hunk)
			vim.keymap.set('n', '<leader>gl', gitsigns.toggle_current_line_blame)
			vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk)
			vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk)
			vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer)
		end,
	},

	{
		'dnlhc/glance.nvim',
		config = function()
			local glance = require 'glance'
			glance.setup {
				mappings = {
					list = {
						['/'] = require('glance').actions.close,
					},
				},
			}
		end,
	},

	{
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				disabled_filetypes = { 'NvimTree' },
				component_separators = '|',
				section_separators = { left = '', right = '' },
			},
			tabline = {},
			sections = {
				lualine_a = {
					{ 'mode', separator = { left = '  ', right = '' } },
				},
				lualine_b = {
					'branch',
					{ 'diagnostics', sources = { 'nvim_workspace_diagnostic' } },
				},
				lualine_c = { { 'filename', path = 1 } },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{ 'location', separator = { left = '', right = '  ' } },
				},
			},
		},
	},

	{
		'levouh/tint.nvim',
		opts = {
			tint = -55,
		},
	},

	{
		'echasnovski/mini.files',
		opts = {},
		keys = {
			{ '<leader>e', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<cr>', desc = 'File explorer' },
		},
	},

	{
		'b0o/incline.nvim',
		opts = {
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
		},
	},

	{
		'harrisoncramer/gitlab.nvim',
		dependencies = {
			'MunifTanjim/nui.nvim',
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
			'stevearc/dressing.nvim', --optional
			'nvim-tree/nvim-web-devicons', --optional
		},
		build = function() require('gitlab.server').build(true) end,
		opts = {},
	},
}
