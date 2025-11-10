---@type NvPluginSpec
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
      local ok, cyberdream = pcall(require, "cyberdream")
      if ok then
        cyberdream.setup(opts)
      end

      vim.g.neosairu_theme = vim.g.neosairu_theme or "cyberdream"

      local ok_theme, theme = pcall(require, "themes.kora_neon")
      if ok_theme and theme.runtime then
        theme.runtime.setup()
      end
    end,
  },
}
