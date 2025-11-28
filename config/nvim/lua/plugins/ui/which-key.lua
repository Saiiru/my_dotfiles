---@type LazySpec
-- NOTE: Keymaps UI
return {
  "folke/which-key.nvim",
  opts = {
    preset = "classic",
    win = {
      no_overlap = false,
    },
    spec = {
      { "<leader>c",  group = "code/LSP",   icon = "" },
      { "<leader>cj", group = "java",       icon = "" },
      { "<leader>d",  group = "debug",      icon = "" },
      { "<leader>f",  group = "find/telescope", icon = "" },
      { "<leader>g",  group = "git",        icon = "" },
      { "<leader>t",  group = "tasks/mise", icon = "" },
      { "<leader>u",  group = "ui/toggles", icon = "" },
      { "<leader>q",  group = "sessions",   icon = "" },
    },
  },
}
