vim.pack.add({ 'https://github.com/mfussenegger/nvim-dap.git' })

-- https://github.com/flutter/flutter/blob/master/packages/flutter_tools/lib/src/debug_adapters/README.md#launchattach-arguments
local dart = {
  adapter = {
    type = 'executable',
    command = 'fvm',
    args = { 'flutter', 'debug_adapter' },
  },
  configurations_provider = function()
    local device = require('util.flutter_util').current_flutter_device
    return {
      {
        type = 'dart',
        request = 'launch',
        name = 'Development (' .. device .. ')',
        program = 'lib/main_development.dart',
        cwd = '${workspaceFolder}',
        toolArgs = { '--flavor', 'development', '-d', device },
      },
      {
        type = 'dart',
        request = 'launch',
        name = 'Production (' .. device .. ')',
        program = 'lib/main_production.dart',
        cwd = '${workspaceFolder}',
        toolArgs = { '--flavor', 'production', '-d', device },
      },
      {
        type = 'dart',
        request = 'launch',
        name = 'Development Release (' .. device .. ')',
        program = 'lib/main_development.dart',
        cwd = '${workspaceFolder}',
        toolArgs = { '--flavor', 'development', '-d', device, '--release' },
      },
      {
        type = 'dart',
        request = 'launch',
        name = 'Production Release (' .. device .. ')',
        program = 'lib/main_production.dart',
        cwd = '${workspaceFolder}',
        toolArgs = { '--flavor', 'production', '-d', device, '--release' },
      },
    }
  end,
}

local dap = require 'dap'

dap.adapters.dart = dart.adapter
dap.providers.configs['dart'] = dart.configurations_provider
