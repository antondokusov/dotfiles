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
      -- add any options here
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    },
    keys = {
      {
        '<leader>aa',
        function() require('sidekick.cli').toggle() end,
        desc = 'Sidekick Toggle CLI',
      },
      {
        '<leader>as',
        function() require('sidekick.cli').select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = 'Select CLI',
      },
      {
        '<leader>at',
        function() require('sidekick.cli').send { msg = '{this}' } end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
      {
        '<leader>av',
        function() require('sidekick.cli').send { msg = '{selection}' } end,
        mode = { 'x' },
        desc = 'Send Visual Selection',
      },
      {
        '<leader>ap',
        function() require('sidekick.cli').prompt() end,
        mode = { 'n', 'x' },
        desc = 'Sidekick Select Prompt',
      },
      {
        '<c-.>',
        function() require('sidekick.cli').focus() end,
        mode = { 'n', 'x', 'i', 't' },
        desc = 'Sidekick Switch Focus',
      },
      -- Example of a keybinding to open Claude directly
      {
        '<leader>ac',
        function() require('sidekick.cli').toggle { name = 'claude', focus = true } end,
        desc = 'Sidekick Toggle Claude',
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
    -- enabled = false,
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
    'kevinhwang91/nvim-bqf',
    dependencies = { 'junegunn/fzf' },
    ft = 'qf',
    enabled = false,
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
