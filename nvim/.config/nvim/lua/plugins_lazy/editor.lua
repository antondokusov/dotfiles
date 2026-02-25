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
      vim.keymap.set('n', '<leader>gl', gitsigns.toggle_current_line_blame)
      vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk)
      vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk)
      vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer)
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
  },
}
