local M = {}

local ns = vim.api.nvim_create_namespace("plan_review")
local state = {
  file = nil,
  comments = {},
  bufnr = nil,
  augroup = nil,
}

local function reviews_dir()
  local dir = vim.fn.expand("~/.claude/plan-reviews")
  vim.fn.mkdir(dir, "p")
  return dir
end

local function json_path(file_path)
  local hash = vim.fn.sha256(file_path)
  return reviews_dir() .. "/" .. hash .. ".json"
end

local function random_id()
  local chars = "0123456789abcdef"
  local id = {}
  for _ = 1, 8 do
    local idx = math.random(1, #chars)
    id[#id + 1] = chars:sub(idx, idx)
  end
  return table.concat(id)
end

local function iso_now()
  return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

local function save_comments()
  if not state.file then return end
  local data = {
    file = state.file,
    comments = state.comments,
  }
  local path = json_path(state.file)
  local f = io.open(path, "w")
  if f then
    f:write(vim.json.encode(data))
    f:close()
  end
end

local function load_comments(file_path)
  local path = json_path(file_path)
  local f = io.open(path, "r")
  if not f then return {} end
  local raw = f:read("*a")
  f:close()
  local ok, data = pcall(vim.json.decode, raw)
  if ok and data and data.comments then
    return data.comments
  end
  return {}
end

local function get_line_text(line)
  if not state.bufnr then return "" end
  local lines = vim.api.nvim_buf_get_lines(state.bufnr, line - 1, line, false)
  return lines[1] or ""
end

local function find_comment_at(line)
  for i, c in ipairs(state.comments) do
    if c.line == line or (c.end_line and line >= c.line and line <= c.end_line) then
      return i, c
    end
  end
  return nil, nil
end

local function refresh_signs()
  if not state.bufnr then return end
  vim.api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)

  for _, c in ipairs(state.comments) do
    local start_line = c.line
    local end_line = c.end_line or c.line

    for ln = start_line, end_line do
      pcall(vim.api.nvim_buf_set_extmark, state.bufnr, ns, ln - 1, 0, {
        sign_text = "▎",
        sign_hl_group = "DiagnosticInfo",
      })
    end
  end
end

local function add_comment(start_line, end_line)
  local prompt
  if end_line and end_line ~= start_line then
    prompt = string.format("Comment (L%d-%d): ", start_line, end_line)
  else
    prompt = string.format("Comment (L%d): ", start_line)
    end_line = nil
  end

  vim.ui.input({ prompt = prompt }, function(input)
    if not input or input == "" then return end

    local comment = {
      id = random_id(),
      line = start_line,
      end_line = end_line,
      content_snippet = get_line_text(start_line),
      body = input,
      created_at = iso_now(),
    }

    table.insert(state.comments, comment)
    save_comments()
    refresh_signs()
    vim.notify(string.format("Comment added at L%d", start_line), vim.log.levels.INFO)
  end)
end

local function edit_comment()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local idx, comment = find_comment_at(line)
  if not comment then
    vim.notify("No comment on this line", vim.log.levels.WARN)
    return
  end

  local prompt
  if comment.end_line then
    prompt = string.format("Edit (L%d-%d): ", comment.line, comment.end_line)
  else
    prompt = string.format("Edit (L%d): ", comment.line)
  end

  vim.ui.input({ prompt = prompt, default = comment.body }, function(input)
    if not input then return end
    if input == "" then
      vim.notify("Comment unchanged (empty input ignored)", vim.log.levels.WARN)
      return
    end
    state.comments[idx].body = input
    save_comments()
    refresh_signs()
    vim.notify("Comment updated", vim.log.levels.INFO)
  end)
end

local function delete_comment()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local idx, comment = find_comment_at(line)
  if not comment then
    vim.notify("No comment on this line", vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = "Delete comment? (y/n): " }, function(input)
    if input and input:lower() == "y" then
      table.remove(state.comments, idx)
      save_comments()
      refresh_signs()
      vim.notify("Comment deleted", vim.log.levels.INFO)
    end
  end)
end

local function show_comment()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local _, comment = find_comment_at(line)
  if not comment then
    vim.notify("No comment on this line", vim.log.levels.WARN)
    return
  end

  local header
  if comment.end_line then
    header = string.format("Comment L%d-%d:", comment.line, comment.end_line)
  else
    header = string.format("Comment L%d:", comment.line)
  end

  local lines = { header, "" }
  for part in (comment.body .. "\n"):gmatch("([^\n]*)\n") do
    table.insert(lines, part)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].modifiable = false

  local width = 60
  local height = math.min(#lines, 10)
  vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = height,
    border = "rounded",
    style = "minimal",
  })

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf })
end

local function list_comments()
  if #state.comments == 0 then
    vim.notify("No comments", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, c in ipairs(state.comments) do
    local text
    if c.end_line then
      text = string.format("[L%d-%d] %s", c.line, c.end_line, c.body)
    else
      text = string.format("[L%d] %s", c.line, c.body)
    end
    table.insert(items, {
      filename = state.file,
      lnum = c.line,
      text = text,
    })
  end

  table.sort(items, function(a, b) return a.lnum < b.lnum end)
  vim.fn.setqflist(items, "r")
  vim.fn.setqflist({}, "a", { title = "Plan Review Comments" })
  vim.cmd("copen")
end

local function next_comment()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local sorted = {}
  for _, c in ipairs(state.comments) do
    table.insert(sorted, c.line)
  end
  table.sort(sorted)

  for _, ln in ipairs(sorted) do
    if ln > line then
      vim.api.nvim_win_set_cursor(0, { ln, 0 })
      return
    end
  end
  if #sorted > 0 then
    vim.api.nvim_win_set_cursor(0, { sorted[1], 0 })
  end
end

local function prev_comment()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local sorted = {}
  for _, c in ipairs(state.comments) do
    table.insert(sorted, c.line)
  end
  table.sort(sorted)

  for i = #sorted, 1, -1 do
    if sorted[i] < line then
      vim.api.nvim_win_set_cursor(0, { sorted[i], 0 })
      return
    end
  end
  if #sorted > 0 then
    vim.api.nvim_win_set_cursor(0, { sorted[#sorted], 0 })
  end
end

local function setup_session_keys()
  local session_keys = require("util.session-keys")

  session_keys.sessions.plan_review = {
    n = {
      { lhs = "c", rhs = function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        add_comment(line, nil)
      end, opts = { desc = "Add comment" } },
      { lhs = "e", rhs = edit_comment, opts = { desc = "Edit comment" } },
      { lhs = "dd", rhs = delete_comment, opts = { desc = "Delete comment" } },
      { lhs = "<CR>", rhs = show_comment, opts = { desc = "Show comment" } },
      { lhs = "l", rhs = list_comments, opts = { desc = "List comments" } },
      { lhs = "J", rhs = next_comment, opts = { desc = "Next comment" } },
      { lhs = "K", rhs = prev_comment, opts = { desc = "Previous comment" } },
      { lhs = "v", rhs = "V", opts = { desc = "Visual line mode" } },
      { lhs = "q", rhs = function()
        save_comments()
        session_keys:stop("plan_review")
        vim.cmd("qa!")
      end, opts = { desc = "Quit review" } },
    },
    v = {
      { lhs = "c", rhs = function()
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
        vim.schedule(function()
          add_comment(start_line, end_line)
        end)
      end, opts = { desc = "Add comment on selection" } },
    },
  }

  session_keys:start("plan_review")
end

function M.setup(file_path)
  math.randomseed(os.time())

  local abs_path = vim.fn.fnamemodify(file_path, ":p")
  state.file = abs_path
  state.comments = load_comments(abs_path)
  state.bufnr = vim.api.nvim_get_current_buf()

  vim.bo[state.bufnr].modifiable = false
  vim.bo[state.bufnr].readonly = true
  vim.wo.wrap = true
  vim.wo.cursorline = true
  vim.api.nvim_set_hl(0, "PlanReviewCursor", { blend = 100, nocombine = true })
  state.prev_guicursor = vim.o.guicursor
  vim.opt.guicursor = "n-o:PlanReviewCursor,v:ver1-PlanReviewCursor,c-i:block"

  setup_session_keys()
  refresh_signs()

  state.augroup = vim.api.nvim_create_augroup("PlanReview", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = state.augroup,
    callback = function()
      save_comments()
      if state.prev_guicursor then
        vim.opt.guicursor = state.prev_guicursor
      end
    end,
  })

  local count = #state.comments
  local msg = "Plan review mode. "
  if count > 0 then
    msg = msg .. count .. " existing comment(s). "
  end
  msg = msg .. "c=comment, e=edit, dd=delete, l=list, q=quit"
  vim.notify(msg, vim.log.levels.INFO)
end

return M
