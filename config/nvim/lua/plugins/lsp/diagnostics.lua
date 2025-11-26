return {
  "artemave/workspace-diagnostics.nvim",
  config = function()
    require("workspace-diagnostics").setup({
      workspace_files = function()
        local gitPath = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if gitPath == nil or gitPath == "" then
          return {}
        end

        local all_files = vim.fn.split(vim.fn.system("git ls-files " .. gitPath), "\n")
        local ignore_dirs = { ".yarn", "node_modules", "dist", "build" }

        local function is_ignored(file)
          for _, dir in ipairs(ignore_dirs) do
            if file:match("^" .. dir .. "/") then
              return true
            end
          end
          return false
        end

        local filtered = {}
        for _, file in ipairs(all_files) do
          if file ~= "" and not is_ignored(file) then
            table.insert(filtered, file)
          end
        end
        return filtered
      end,
    })
  end,
}
