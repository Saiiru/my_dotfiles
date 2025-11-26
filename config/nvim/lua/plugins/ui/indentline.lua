return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = { char = "│", highlight = "Comment" },
    scope = { enabled = true, show_start = false, show_end = false },
    exclude = {
      filetypes = { "help", "alpha", "dashboard", "snacks_dashboard", "neo-tree", "oil" },
      buftypes = { "terminal", "nofile" },
    },
  },
}
