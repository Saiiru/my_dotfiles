-- Mise-Tmux Integration with Error Parsing
local M = {}

function M.parse_mise_toml()
  local mise_file = vim.fn.findfile(".mise.toml", ".;")
  if mise_file == "" then return {} end

  local tasks = {}
  local in_tasks = false

  for line in io.lines(mise_file) do
    if line:match("^%[tasks%]") then
      in_tasks = true
    elseif line:match("^%[") then
      in_tasks = false
    elseif in_tasks and line:match("^%s*([%w_-]+)%s*=") then
      local task_name = line:match("^%s*([%w_-]+)%s*=")
      table.insert(tasks, task_name)
    end
  end

  return tasks
end

local function ensure_tmux()
  if not vim.env.TMUX then
    vim.notify("[Mise] Not in tmux session", vim.log.levels.WARN)
    return false
  end
  return true
end

function M.run_in_tmux(task, split_type)
  if not ensure_tmux() then return end
  local cmd_map = {
    split = "split-window -v",
    vsplit = "split-window -h",
    window = "new-window",
  }
  local tmux_cmd = cmd_map[split_type] or cmd_map.split
  local project_root = vim.fn.getcwd()
  local full_cmd = string.format(
    "tmux %s 'cd %s && mise run %s; read -p " .. string.char(34) .. "Press enter to close..." .. string.char(34) .. "'",
    tmux_cmd,
    vim.fn.shellescape(project_root),
    task
  )
  vim.fn.system(full_cmd)
  vim.notify(string.format("[Mise] Running '%s' in tmux %s", task, split_type), vim.log.levels.INFO)
end

function M.task_picker()
  local tasks = M.parse_mise_toml()
  if #tasks == 0 then
    vim.notify("[Mise] No tasks found in .mise.toml", vim.log.levels.WARN)
    return
  end
  vim.ui.select(tasks, { prompt = "Select mise task:" }, function(choice)
    if choice then M.run_in_tmux(choice, "split") end
  end)
end

return M
