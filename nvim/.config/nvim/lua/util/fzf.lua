local M = {}

local fzf_opts = '--layout=reverse'
local fzf_env = 'export FZF_DEFAULT_OPTS_FILE=~/.config/fzf/fzfrc; '

local function zellij_run(cmd)
  os.execute('zellij action new-pane -f -c -n " " -- sh -c ' .. vim.fn.shellescape(fzf_env .. cmd))
end

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

  zellij_run("fzf " .. fzf_opts .. " >> " .. result_pipe)
end

--- Opens fzf in a zellij pane with a list of options and returns the selected one
--- @param options table A list of strings to choose from
--- @param callback function A callback function that receives the selected string
--- @return nil
M.select = function(options, callback)
  if not options or #options == 0 then
    vim.notify("No options provided to fzf_select", vim.log.levels.WARN)
    return
  end

  local result_pipe = "/tmp/nvim_select_result"
  local input_file = "/tmp/nvim_select_input"

  os.execute("rm -f " .. result_pipe)
  os.execute("rm -f " .. input_file)

  os.execute("mkfifo " .. result_pipe)

  local file = io.open(input_file, "w")
  if not file then
    vim.notify("Failed to create input file for fzf", vim.log.levels.ERROR)
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

  zellij_run("cat " .. input_file .. " | fzf " .. fzf_opts .. " --disabled --bind j:down,k:up >> " .. result_pipe)
end

--- Opens fzf with live ripgrep in a zellij pane
--- @param initial_query string|nil Pre-filled search query
M.grep = function(initial_query)
  initial_query = initial_query or ""
  local result_pipe = "/tmp/nvim_zellij_grep"

  os.execute("rm -f " .. result_pipe)
  os.execute("mkfifo " .. result_pipe)

  vim.fn.jobstart("head -n 1 " .. result_pipe, {
    on_stdout = function(_, data)
      local result = data[1]
      if result and result ~= "" then
        local file, line = result:match("^(.-):(%d+):")
        if file and line then
          vim.cmd("edit " .. vim.fn.fnameescape(file))
          vim.fn.cursor(tonumber(line), 0)
        end
      end
      os.execute("rm -f " .. result_pipe)
    end,
  })

  local query = vim.fn.shellescape(initial_query)
  local rg_cmd = "rg --line-number --column --no-heading --color=always"
    .. " --colors 'match:fg:0x44,0x44,0x44' --colors 'match:style:bold'"
    .. " --colors 'path:fg:0x88,0x88,0x88' --colors 'line:fg:0x88,0x88,0x88'"
    .. " --colors 'column:fg:0x88,0x88,0x88'"
  zellij_run(
    "fzf --ansi --disabled --layout=reverse"
    .. ' --bind "change:reload:' .. rg_cmd .. ' {q} || true"'
    .. ' --bind "start:reload:' .. rg_cmd .. ' {q} || true"'
    .. " --delimiter=:"
    .. ' --preview "bat --style=numbers --color=always --highlight-line {2} --theme=theme1 {1}" --preview-window +{2}-/2'
    .. " --preview-window up:60%"
    .. " --query=" .. query
    .. " >> " .. result_pipe
  )
end

--- Opens fzf grep with the current visual selection as initial query
M.grep_visual = function()
  vim.cmd('noau normal! "vy')
  local text = vim.fn.getreg("v"):gsub("\n", "")
  M.grep(text)
end

--- Setup fzf as the default vim.ui.select
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
