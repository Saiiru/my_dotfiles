return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        layout = { preset = "telescope", cycle = false },
        highlight = { selection = "IncSearch", match = "Search" },
        -- use defaults to avoid UIEnter crash
      },
      input = { enabled = true },
      quickfile = { enabled = true, exclude = { "latex" } },
      image = { enabled = function() return vim.bo.filetype == "markdown" end },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    keys = {
      { "<leader>pf", function() require("snacks").picker.files() end, desc = "Find Files" },
      { "<leader>ps", function() require("snacks").picker.grep() end, desc = "Grep" },
      { "<leader>pk", function() require("snacks").picker.keymaps({ layout = "telescope" }) end, desc = "Keymaps" },
      { "<leader>pws", function() require("snacks").picker.grep_word() end, desc = "Grep word", mode = { "n", "x" } },
      { "<leader>th", function() require("snacks").picker.colorschemes({ layout = "telescope" }) end, desc = "Themes" },
      { "<leader>lg", function() require("snacks").lazygit() end, desc = "Lazygit" },
      { "<leader>dB", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>pt", function() require("snacks").picker.todo_comments() end, desc = "Todo" },
    },
  },
}
