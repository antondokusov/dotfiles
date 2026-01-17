local M = {}

M.current_flutter_device = 'GM1900'

function M.start_daemon_and_poll_devices()
  local daemon = require 'util.flutter_daemon'

  if not daemon.is_running() then
    local started = daemon.start()
    if not started then
      vim.notify('Failed to start Flutter daemon', vim.log.levels.ERROR)
      return
    end

    vim.defer_fn(function()
      daemon.send_command('device.enable')
    end, 100)
  end
end

function M.select_flutter_device()
  local daemon = require 'util.flutter_daemon'

  daemon.send_command('device.getDevices', nil, function(devices, error)
    if error then
      vim.notify('Error fetching devices: ' .. error, vim.log.levels.ERROR)
      return
    end

    if not devices or #devices == 0 then
      vim.notify('No Flutter devices found', vim.log.levels.WARN)
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
