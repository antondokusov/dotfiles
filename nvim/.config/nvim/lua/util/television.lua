local M = {}

M.find = function()
  local result_pipe = "/tmp/nvim_zellij_picker"

  os.execute("rm -f " .. result_pipe)
  os.execute("mkfifo " .. result_pipe)

  vim.fn.jobstart("head -n 1 " .. result_pipe, {
    on_stdout = function(_, data)
      local file = data[1]
      if file and file ~= "" then
        vim.cmd("find " .. file)
      end
      os.execute("rm -f " .. result_pipe)
    end,
  })

  os.execute('zellij action new-pane -f -c -n " " -- sh -c "tv files --no-preview --no-status-bar >> ' .. result_pipe .. '"')
end

--- Opens television in a zellij pane with a list of options and returns the selected one
--- @param options table A list of strings to choose from
--- @param callback function A callback function that receives the selected string
--- @return nil
M.select = function(options, callback)
  if not options or #options == 0 then
    vim.notify("No options provided to television_select", vim.log.levels.WARN)
    return
  end

  local result_pipe = "/tmp/nvim_select_result"
  local input_file = "/tmp/nvim_select_input"

  os.execute("rm -f " .. result_pipe)
  os.execute("rm -f " .. input_file)

  os.execute("mkfifo " .. result_pipe)

  local file = io.open(input_file, "w")
  if not file then
    vim.notify("Failed to create input file for television", vim.log.levels.ERROR)
    return
  end

  for _, option in ipairs(options) do
    file:write(option .. "\n")
  end
  file:close()

  vim.fn.jobstart("head -n 1 " .. result_pipe, {
    on_stdout = function(_, data)
      local selection = data[1]

      os.execute("rm -f " .. result_pipe)
      os.execute("rm -f " .. input_file)

      if selection and selection ~= "" then
        callback(selection)
      end
    end,
  })

  os.execute('zellij action new-pane -f -c -n " " -- sh -c "cat ' ..
    input_file .. ' | tv --no-preview --no-status-bar >> ' .. result_pipe .. '"')
end

--- Setup television as the default vim.ui.select
M.setup_ui_select = function()
  vim.ui.select = function(items, opts, on_choice)
    opts = opts or {}

    local formatted_items = {}
    for i, item in ipairs(items) do
      if opts.format_item then
        formatted_items[i] = opts.format_item(item)
      else
        formatted_items[i] = tostring(item)
      end
    end

    M.select(formatted_items, function(selected)
      local idx = nil
      for i, formatted in ipairs(formatted_items) do
        if formatted == selected then
          idx = i
          break
        end
      end

      if idx then
        on_choice(items[idx], idx)
      else
        on_choice(nil, nil)
      end
    end)
  end
end

return M
