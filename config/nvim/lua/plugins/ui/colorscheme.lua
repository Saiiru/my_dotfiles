return {
  {
    "scottmckendry/cyberdream.nvim",
    name = "cyberdream",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      borderless_telescope = true,
      theme = { variant = "default", highlights = {} },
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      require("utils.colors").setup()
      require("utils.colors").set("cyberdream")
    end,
  },
  { "folke/tokyonight.nvim", name = "tokyonight", opts = { transparent = true } },
  { "rose-pine/neovim", name = "rose-pine", opts = { styles = { transparency = true } } },
}
