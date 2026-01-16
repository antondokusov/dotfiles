local M = {}

M.current_flutter_device = 'GM1900'

function M.select_flutter_device()
  local daemon = require 'config.flutter_daemon'
  if not daemon.is_running() then
    local started = daemon.start()
    if not started then
      vim.notify('Failed to start Flutter daemon', vim.log.levels.ERROR)
      return
    end
  end

  daemon.send_command('device.getDevices', nil, function(devices, error)
    if error then
      vim.notify('Error fetching devices: ' .. error, vim.log.levels.ERROR)
      return
    end

    vim.ui.select(devices, {
      prompt = 'Select Flutter device:',
      format_item = function(device)
        return device.name .. ' (' .. device.platform .. ')'
      end,
    }, function(selected)
      if selected then
        M.current_flutter_device = selected.id
        vim.notify('Selected Flutter device: ' .. selected.name, vim.log.levels.INFO)
      else
        vim.notify('No Flutter device selected', vim.log.levels.WARN)
      end
    end)
  end)
end

return M
