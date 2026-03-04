return {
  {
    'folke/sidekick.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      nes = {
        enabled = true,
        diff = {
          inline = "chars",
        },
      },
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    },
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
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
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


      vim.keymap.set('n', '<leader>F', fzf.grep)
    end,
  },

  {
    'SmiteshP/nvim-navbuddy',
    dependencies = {
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
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
        },
      }

      vim.keymap.set('n', '}', gitsigns.next_hunk)
      vim.keymap.set('n', '{', gitsigns.prev_hunk)
    end,
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
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>g', '<cmd>DiffviewOpen<cr>', desc = 'Diffview open' },
    },
    opts = {
      hooks = {
        diff_buf_read = function(bufnr)
          local name = vim.api.nvim_buf_get_name(bufnr)
          local gitdir, relpath = name:match('^diffview://(.+%.git)/:%d+:/(.+)$')
          if gitdir and relpath then
            local toplevel = gitdir:gsub('/.git$', '')
            require('gitsigns').attach(bufnr, {
              file = toplevel .. '/' .. relpath,
              toplevel = toplevel,
              gitdir = gitdir,
            })
          end
        end,
      },
      keymaps = {
        disable_defaults = true,
        view = {
          { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
          { 'n', '<tab>', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle files panel' } },
          { 'n', ']', ']c', { desc = 'Next hunk' } },
          { 'n', '[', '[c', { desc = 'Previous hunk' } },
          { 'n', 'r', '<cmd>Gitsigns reset_hunk<cr>', { desc = 'Reset hunk' } },
          { 'n', 'b', '<cmd>Gitsigns blame_line<cr>', { desc = 'Blame line' } },
        },
        file_panel = {
          { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
          { 'n', '<tab>', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle files panel' } },
        },
      },
    },
  },
}
