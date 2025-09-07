function _G.qftf(info)
	local items
	local ret = {}
	if info.quickfix == 1 then
		items = vim.fn.getqflist({ id = info.id, items = 0 }).items
	else
		items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	end
	local limit = 31
	local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
	local validFmt = '%s │%5d:%-3d│%s %s'
	for i = info.start_idx, info.end_idx do
		local e = items[i]
		local fname = ''
		local str
		if e.valid == 1 then
			if e.bufnr > 0 then
				fname = vim.fn.bufname(e.bufnr)
				if fname == '' then
					fname = '[No Name]'
				else
					fname = fname:gsub('^' .. vim.env.HOME, '~')
				end
				-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
				if #fname <= limit then
					fname = fnameFmt1:format(fname)
				else
					fname = fnameFmt2:format(fname:sub(1 - limit))
				end
			end
			local lnum = e.lnum > 99999 and -1 or e.lnum
			local col = e.col > 999 and -1 or e.col
			-- local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
			str = validFmt:format(fname, lnum, col, e.type, e.text)
		else
			str = e.text
		end
		table.insert(ret, str)
	end
	return ret
end

vim.o.quickfixtextfunc = '{info -> v:lua._G.qftf(info)}'

return {
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = '<TAB>',
          },
        },
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        },
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
        keymap = { fzf = { ['ctrl-a'] = 'select-all+accept' } },
        defaults = { formatter = 'path.filename_first' },
      }

      fzf.register_ui_select()

      vim.keymap.set('n', '<leader>f', fzf.files)
      vim.keymap.set('n', '<leader>F', fzf.grep)
      vim.keymap.set('n', '<leader>la', fzf.lsp_code_actions)
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
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
        },
      }

      vim.keymap.set('n', '}', gitsigns.next_hunk)
      vim.keymap.set('n', '{', gitsigns.prev_hunk)
      vim.keymap.set('n', '<leader>gl', gitsigns.toggle_current_line_blame)
      vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk)
      vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk)
      vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer)
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
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neotest/nvim-nio',
      'nvim-treesitter/nvim-treesitter',
      'sidlatau/neotest-dart',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-dart' {
            command = 'fvm flutter',
            use_lsp = true,
            custom_test_method_names = { 'blocTest' },
          },
        },
      }
    end,
  },

  {
    'kevinhwang91/nvim-bqf',
    dependencies = { 'junegunn/fzf' },
    ft = 'qf',
    config = function()
      require('bqf').setup {
        func_map = {
          fzffilter = '/',
        },
        filter = {
          fzf = {
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' },
          },
        },
      }
    end,
  },

  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
}
