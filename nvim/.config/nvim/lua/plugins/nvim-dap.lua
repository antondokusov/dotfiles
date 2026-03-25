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
dap.defaults.dart.exception_breakpoints = {}
dap.defaults.fallback.exception_breakpoints = {}

-- Zellij tab icon: show ▶️ prefix while DAP session is active
local zellij_tab_icon = require('util.zellij-tab-icon')
local zellij_dap_handle = nil

dap.listeners.after.event_initialized['zellij-tab-icon'] = function()
  if zellij_dap_handle then return end
  zellij_dap_handle = zellij_tab_icon.add('▶️ ')
end

local function on_dap_end()
  if not zellij_dap_handle then return end
  zellij_tab_icon.remove(zellij_dap_handle)
  zellij_dap_handle = nil
end

dap.listeners.after.event_terminated['zellij-tab-icon'] = on_dap_end
dap.listeners.after.event_exited['zellij-tab-icon'] = on_dap_end

local group = vim.api.nvim_create_augroup('zellij-dap-tab-icon', { clear = true })
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = on_dap_end,
})
