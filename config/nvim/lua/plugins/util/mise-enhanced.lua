return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { { "<leader>t", group = "tasks" } })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>tm",
        function()
          require("utils.mise_enhanced").task_picker()
        end,
        desc = "Mise task picker",
      },
      {
        "<leader>tr",
        function()
          vim.ui.input({ prompt = "Task name: " }, function(task)
            if task then
              require("utils.mise_enhanced").run_in_tmux(task, "split")
            end
          end)
        end,
        desc = "Run mise task (prompt)",
      },
      {
        "<leader>ts",
        function()
          require("utils.mise_enhanced").task_picker()
        end,
        desc = "Run in split",
      },
      {
        "<leader>tv",
        function()
          local mise = require("utils.mise_enhanced")
          local tasks = mise.parse_mise_toml()
          vim.ui.select(tasks, { prompt = "Task:" }, function(choice)
            if choice then mise.run_in_tmux(choice, "vsplit") end
          end)
        end,
        desc = "Run in vsplit",
      },
      {
        "<leader>tw",
        function()
          local mise = require("utils.mise_enhanced")
          local tasks = mise.parse_mise_toml()
          vim.ui.select(tasks, { prompt = "Task:" }, function(choice)
            if choice then mise.run_in_tmux(choice, "window") end
          end)
        end,
        desc = "Run in window",
      },
    },
  },
}
