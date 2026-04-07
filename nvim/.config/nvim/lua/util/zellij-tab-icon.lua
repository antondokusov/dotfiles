local M = {}

local function strip_icon(name, icon)
  return (name:gsub(icon, '', 1))
end

function M.add(icon)
  if not vim.env.ZELLIJ then
    return nil
  end

  local result = vim.system({ 'zellij', 'action', 'current-tab-info', '--json' }):wait()
  if result.code ~= 0 then
    return nil
  end

  local ok, info = pcall(vim.json.decode, result.stdout)
  if not ok then
    return nil
  end

  local handle = { tab_id = info.tab_id, icon = icon, cleared = false }
  local name = strip_icon(info.name, icon)

  vim.system({ 'zellij', 'action', 'rename-tab', icon .. name, '--tab-id', tostring(info.tab_id) })

  return handle
end

function M.remove(handle)
  if not handle or handle.cleared then
    return
  end
  handle.cleared = true

  local result = vim.system({ 'zellij', 'action', 'list-tabs', '--json' }):wait()
  if result.code ~= 0 then
    return
  end

  local ok, tabs = pcall(vim.json.decode, result.stdout)
  if not ok then
    return
  end

  for _, tab in ipairs(tabs) do
    if tab.tab_id == handle.tab_id then
      local name = strip_icon(tab.name, handle.icon)
      vim.system({ 'zellij', 'action', 'rename-tab', name, '--tab-id', tostring(handle.tab_id) }):wait()
      return
    end
  end
end

return M
