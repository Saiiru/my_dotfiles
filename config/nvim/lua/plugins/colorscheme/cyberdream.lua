return {
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
    lazy = false,
    opts = { transparent = true, italic_comments = true, borderless_telescope = true },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      vim.cmd.colorscheme("cyberdream")
    end,
  },
}
