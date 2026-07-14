vim.pack.add({ 'https://github.com/mfussenegger/nvim-dap.git' })

-- https://github.com/flutter/flutter/blob/master/packages/flutter_tools/lib/src/debug_adapters/README.md#launchattach-arguments
local flutter = require 'util.flutter_util'

local dart = {
  type = 'executable',
  command = 'flutter',
  args = { 'debug_adapter' },
  enrich_config = function(configuration, on_config)
    local device = flutter.current_flutter_device
    if device and device ~= '' then
      configuration = vim.deepcopy(configuration)
      configuration.toolArgs = configuration.toolArgs or {}
      vim.list_extend(configuration.toolArgs, { '-d', device })
    end
    on_config(configuration)
  end,
}

local dap = require 'dap'

dap.adapters.dart = dart

dap.defaults.dart.exception_breakpoints = {}
dap.defaults.fallback.exception_breakpoints = {}

local dap_logs = require 'util.dap-logs'

dap.defaults.dart.on_output = dap_logs.on_output

dap.listeners.after.event_initialized['dap-logs'] = dap_logs.open
dap.listeners.after.event_terminated['dap-logs'] = dap_logs.close
dap.listeners.after.event_exited['dap-logs'] = dap_logs.close

local dap_logs_group = vim.api.nvim_create_augroup('dap-logs-cleanup', { clear = true })
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = dap_logs_group,
  callback = dap_logs.close_all,
})

dap.listeners.after['event_dart.debuggerUris']['devtools'] = function(session, body)
  if body and body.vmServiceUri then
    session.dart_vm_service_uri = body.vmServiceUri
  end
end

-- Zellij tab icon: show 🚀 prefix while DAP session is active
local zellij_tab_icon = require('util.zellij-tab-icon')
local zellij_dap_handle = nil

dap.listeners.after.event_initialized['zellij-tab-icon'] = function()
  if zellij_dap_handle then return end
  zellij_dap_handle = zellij_tab_icon.add('🚀 ')
end

local function on_dap_end()
  local sessions = require('dap').sessions()
  if next(sessions) ~= nil then return end
  if zellij_dap_handle then
    zellij_tab_icon.remove(zellij_dap_handle)
    zellij_dap_handle = nil
  end
  require('util.devtools').stop()
end

dap.listeners.after.event_terminated['zellij-tab-icon'] = on_dap_end
dap.listeners.after.event_exited['zellij-tab-icon'] = on_dap_end

local group = vim.api.nvim_create_augroup('zellij-dap-tab-icon', { clear = true })
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = on_dap_end,
})
