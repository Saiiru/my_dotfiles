return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>tm",
      function()
        local tasks = require("utils.mise").list_tasks()
        if #tasks == 0 then
          vim.notify("No mise tasks found", vim.log.levels.WARN)
          return
        end
        require("snacks").picker.select({
          title = "Mise Tasks",
          items = tasks,
          on_confirm = function(item)
            require("utils.mise").run(item.text)
          end,
        })
      end,
      desc = "Run mise task (picker)",
    },
    {
      "<leader>tr",
      function()
        local task = vim.fn.input("mise run ")
        require("utils.mise").run(task)
      end,
      desc = "Run mise task (prompt)",
    },
  },
}
