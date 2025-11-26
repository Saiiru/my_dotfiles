return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = function()
    return {
      picker = { enabled = true },
    }
  end,
  keys = {
    {
      "<leader>tt",
      function()
        local tasks = require("utils.mise").list_tasks()
        require("snacks").picker.select({
          title = "Mise Tasks",
          items = tasks,
          on_confirm = function(item)
            require("utils.mise").run(item.text, "split-window -h")
          end,
        })
      end,
      desc = "Mise tasks (tmux split)"
    },
    {
      "<leader>tr",
      function()
        local task = vim.fn.input("mise run ")
        require("utils.mise").run(task, "split-window")
      end,
      desc = "Run mise task (tmux split)"
    },
  },
}
