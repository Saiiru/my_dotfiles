local M = {}

local function project_root()
  local root = vim.fs.dirname(vim.fs.find({ '.mise.toml', '.git' }, { upward = true })[1] or vim.loop.cwd())
  return root or vim.loop.cwd()
end

local function parse_tasks(root)
  local path = root .. "/.mise.toml"
  local f = io.open(path, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  local tasks = {}
  local in_tasks = false
  for line in content:gmatch("[^\n]+") do
    local trimmed = line:match("^%s*(.-)%s*$")
    if trimmed:match("^%[tasks%]") then
      in_tasks = true
    elseif in_tasks then
      local name = trimmed:match("^([%w%-%_]+)%s*=")
      if name then table.insert(tasks, name) end
      if trimmed:match("^%[.+%]") then break end
    end
  end
  table.sort(tasks)
  return tasks
end

function M.list_tasks()
  return parse_tasks(project_root())
end

function M.run(task)
  if not task or task == "" then
    vim.notify("Mise: task vazio", vim.log.levels.WARN)
    return
  end
  local cmd = string.format("cd %s && mise run %s", project_root(), task)
  local ok, toggleterm = pcall(require, "toggleterm.terminal")
  if ok then
    local Terminal = toggleterm.Terminal
    local term = Terminal:new({ direction = "horizontal", cmd = cmd, close_on_exit = false })
    term:open()
  else
    vim.notify("ToggleTerm não disponível; executando jobstart", vim.log.levels.INFO)
    vim.fn.jobstart(cmd, { detach = true })
  end
end

return M
