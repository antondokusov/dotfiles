local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then return end

local actions = require 'telescope.actions'

local function telescope_buffer_dir() return vim.fn.expand '%:p:h' end

telescope.setup {
	defaults = {
		path_display = { 'smart' },
		mappings = {
			n = {
				['<esc>'] = actions.close,
				['/'] = actions.close, -- for one hand navigation
			},
		},
	},
	pickers = {
		diagnostics = {
			layout_strategy = 'vertical',
			initial_mode = 'normal',
		},
		live_grep = {
			layout_strategy = 'vertical',
		},
		lsp_references = {
			theme = 'ivy',
			initial_mode = 'normal',
			layout_strategy = 'vertical',
		},
		lsp_implementations = {
			layout_strategy = 'vertical',
			initial_mode = 'normal',
		},
		find_files = require('telescope.themes').get_dropdown { previewer = false },
		lsp_document_symbols = require('telescope.themes').get_dropdown {
			initial_mode = 'normal',
		},
	},
	extensions = {
		['ui-select'] = {
			require('telescope.themes').get_cursor {
				previewer = false,
				initial_mode = 'normal',
			},
		},
		['zf-native'] = {
			file = {
				enable = true,
				highlight_results = true,
				match_filename = true,
			},
			--[[ generic = { ]]
			--[[ 	enable = true, ]]
			--[[ 	highlight_results = true, ]]
			--[[ 	match_filename = false, ]]
			--[[ }, ]]
		},
		file_browser = {
			theme = 'dropdown',
			path = '%:p:h',
			cwd = telescope_buffer_dir(),
			initial_mode = 'normal',
			previewer = false,
			layout_config = { height = 40 },
			grouped = true,
			display_stat = { date = false, size = false },
		},
	},
}

telescope.load_extension 'ui-select'
telescope.load_extension 'file_browser'
--[[ telescope.load_extension 'fzf' ]]
telescope.load_extension 'zf-native'
telescope.load_extension 'git_worktree'
