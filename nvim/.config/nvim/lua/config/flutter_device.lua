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

    local device_items = {}
    for _, device in ipairs(devices) do
      table.insert(device_items, device.name .. ' (' .. device.platform .. ')')
    end

    require('config.util').television_select(device_items, function(selected)
      if selected then
        for _, device in ipairs(devices) do
          if selected == device.name .. ' (' .. device.platform .. ')' then
            M.current_flutter_device = device.id
            vim.notify('Selected Flutter device: ' .. device.name, vim.log.levels.INFO)
            return
          end
        end
      else
        vim.notify('No Flutter device selected', vim.log.levels.WARN)
      end
    end
    )
  end)
end

return M
