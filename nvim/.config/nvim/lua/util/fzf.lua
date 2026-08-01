local M = {}

local fzf_opts = '--layout=reverse'

--- Run `cmd` in a floating terminal and hand its stdout to `on_result`.
--- `on_result` receives the output lines on a clean exit, or an empty table when the
--- user aborts (fzf exits 130 on <Esc>/<C-c>, 1 when nothing matched).
--- The border is left unset on purpose so it inherits 'winborder'; style=minimal keeps
--- Nvim 0.12 from drawing a statusline inside the float.
local function float_run(cmd, on_result)
  local out = vim.fn.tempname()
  local prev_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.85)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    style = 'minimal',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
  })

  -- fzfrc uses bg:-1, so fzf paints with the window's background. Floats default to
  -- NormalFloat, which is a shade off Normal in theme1 — remap so the picker sits on
  -- the same background as the editor.
  vim.wo[win].winhighlight = 'NormalFloat:Normal'

  vim.fn.jobstart({ 'sh', '-c', cmd .. ' >' .. vim.fn.shellescape(out) }, {
    term = true,
    env = { FZF_DEFAULT_OPTS_FILE = vim.fn.expand '~/.config/fzf/fzfrc' },
    on_exit = function(_, code)
      vim.schedule(function()
        vim.cmd.stopinsert()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
        if vim.api.nvim_win_is_valid(prev_win) then
          vim.api.nvim_set_current_win(prev_win)
        end

        local lines = {}
        if code == 0 and vim.fn.filereadable(out) == 1 then
          lines = vim.fn.readfile(out)
        end
        vim.fn.delete(out)

        on_result(lines)
      end)
    end,
  })

  vim.cmd.startinsert()
end

M.find = function()
  local sep = "\1"
  local source = "fd --type f --hidden --strip-cwd-prefix --exclude .git"
  local format = "awk -F/ 'BEGIN{OFS=\"\\1\"} {print $NF, \"\\033[2m • \" $0 \"\\033[0m\", $0}'"
  local fzf_cmd = "fzf " .. fzf_opts
    .. " --ansi --delimiter='" .. sep .. "' --with-nth=1,2 --nth=1 --accept-nth=3"
    .. " --tiebreak=pathname"

  float_run(source .. " | " .. format .. " | " .. fzf_cmd, function(lines)
    local file = lines[1]
    if file and file ~= "" then
      vim.cmd.edit(vim.fn.fnameescape(file))
    end
  end)
end

--- Opens fzf in a floating terminal with a list of options and returns the selected one
--- @param options table A list of strings to choose from
--- @param callback function Receives the selected string and its 1-based index, or nil,nil
--- @return nil
M.select = function(options, callback)
  if not options or #options == 0 then
    vim.notify("No options provided to fzf_select", vim.log.levels.WARN)
    return
  end

  -- Prefix each line with its index and select on that, so duplicate labels still
  -- resolve to the entry the user actually picked.
  local sep = "\1"
  local lines = {}
  for i, option in ipairs(options) do
    lines[i] = i .. sep .. (tostring(option):gsub('%c', ' '))
  end

  local input = vim.fn.tempname()
  if vim.fn.writefile(lines, input) ~= 0 then
    vim.notify("Failed to create input file for fzf", vim.log.levels.ERROR)
    return
  end

  local cmd = "cat " .. vim.fn.shellescape(input) .. " | fzf " .. fzf_opts
    .. " --delimiter='" .. sep .. "' --with-nth=2 --accept-nth=1"
    .. " --disabled --bind j:down,k:up"

  float_run(cmd, function(result)
    vim.fn.delete(input)

    local idx = tonumber(result[1])
    if idx and options[idx] then
      callback(options[idx], idx)
    else
      callback(nil, nil)
    end
  end)
end

--- Opens fzf with live ripgrep in a floating terminal
--- @param initial_query string|nil Pre-filled search query
M.grep = function(initial_query)
  local query = vim.fn.shellescape(initial_query or "")
  local rg_cmd = "rg --line-number --column --no-heading --color=always"
    .. " --colors 'match:fg:0x44,0x44,0x44' --colors 'match:style:bold'"
    .. " --colors 'path:fg:0x88,0x88,0x88' --colors 'line:fg:0x88,0x88,0x88'"
    .. " --colors 'column:fg:0x88,0x88,0x88'"

  local cmd = "fzf --ansi --disabled --layout=reverse"
    .. ' --bind "change:reload:' .. rg_cmd .. ' {q} || true"'
    .. ' --bind "start:reload:' .. rg_cmd .. ' {q} || true"'
    .. " --delimiter=:"
    .. ' --preview "bat --style=numbers --color=always --highlight-line {2} --theme=theme1 {1}" --preview-window +{2}-/2'
    .. " --preview-window up:60%"
    .. " --query=" .. query

  float_run(cmd, function(lines)
    local result = lines[1]
    if not result or result == "" then return end

    local file, line, col = result:match("^(.-):(%d+):(%d+):")
    if not file then return end

    vim.cmd.edit(vim.fn.fnameescape(file))
    vim.api.nvim_win_set_cursor(0, { tonumber(line), math.max(tonumber(col) - 1, 0) })
  end)
end

--- Opens fzf grep with the current visual selection as initial query
M.grep_visual = function()
  local saved = vim.fn.getreginfo("v")
  vim.cmd('noau normal! "vy')
  local text = (vim.fn.getreg("v"):gsub("\n.*", ""))
  vim.fn.setreg("v", saved)
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

    M.select(formatted_items, function(_, idx)
      if idx then
        on_choice(items[idx], idx)
      else
        on_choice(nil, nil)
      end
    end)
  end
end

return M
