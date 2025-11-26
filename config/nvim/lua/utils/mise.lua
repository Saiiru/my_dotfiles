local M = {}

local function parse_tasks(root)
  local path = root .. "/.mise.toml"
  local f = io.open(path, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  local tasks = {}
  for line in content:gmatch("[\r\n]*([\w%-%_]+)%s*=%s*\"?.-\"?") do
    table.insert(tasks, line)
  end
  return tasks
end

local function project_root()
  local root = vim.fs.dirname(vim.fs.find({'.mise.toml','.git'}, { upward = true })[1] or vim.loop.cwd())
  return root or vim.loop.cwd()
end

function M.list_tasks()
  return parse_tasks(project_root())
end

local function run_in_tmux(cmd, where)
  where = where or "split-window"
  local job = string.format("tmux %s '%s'", where, cmd)
  vim.fn.jobstart(job)
end

function M.run(task, where)
  if not task or task == "" then
    vim.notify("Mise: no task provided", vim.log.levels.WARN)
    return
  end
  local cmd = string.format("cd %s && mise run %s", project_root(), task)
  run_in_tmux(cmd, where)
end

return M
