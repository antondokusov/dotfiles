local python = {
  adapter = {
    type = 'executable',
    command = 'python3',
    args = { '-m', 'debugpy.adapter' },
  },
  configurations = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
    },
  },
}

-- https://github.com/flutter/flutter/blob/master/packages/flutter_tools/lib/src/debug_adapters/README.md#launchattach-arguments
local dart = {
  adapter = {
    type = 'executable',
    command = 'fvm',
    args = { 'flutter', 'debug_adapter' },
  },
  configurations_provider = function()
    local device = require('config.flutter_device').current_flutter_device
    return {
      {
        type = 'dart',
        request = 'launch',
        name = 'Launch dev',
        program = 'lib/main_development.dart',
        cwd = '${workspaceFolder}',
        toolArgs = { '--flavor', 'development', '-d', device, '--dart-define-from-file=api_keys.json' },
      },
      {
        type = 'dart',
        request = 'launch',
        name = 'Launch prod',
        program = 'lib/main_production.dart',
        cwd = '${workspaceFolder}',
        toolArgs = { '--flavor', 'production', '-d', device, '--dart-define-from-file=api_keys.json' },
      },
    }
  end,
}

return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'

      dap.adapters.python = python.adapter
      dap.configurations.python = python.configurations

      dap.adapters.dart = dart.adapter
      dap.providers.configs['dart'] = dart.configurations_provider

      dap.defaults.dart.exception_breakpoints = { 'raised' }
      -- dap.defaults.dart.exception_breakpoints = { 'uncaught' }
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    opts = {
      controls = { enabled = false },
      layouts = {
        {
          elements = {
            'repl',
          },
          size = 10,
          position = 'bottom', -- Can be "bottom" or "top"
        },
        {
          -- You can change the order of elements in the sidebar
          elements = {
            -- Provide IDs as strings or tables with "id" and "size" keys
            {
              id = 'scopes',
              size = 0.3, -- Can be float or integer > 1
            },
            { id = 'breakpoints', size = 0.3 },
            { id = 'stacks',      size = 0.3 },
          },
          size = 40,
          position = 'left', -- Can be "left" or "right"
        },
      },
    },
  },

  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
  },
}
