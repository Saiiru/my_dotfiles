return {
  require("plugins.editor.treesitter"),
  require("plugins.editor.auto-pairs"),
  require("plugins.editor.surround"),
  require("plugins.editor.harpoon"),
  require("plugins.editor.telescope"),
  require("plugins.editor.oil"),
  require("plugins.editor.mini"),
  require("plugins.editor.snacks"),
  require("plugins.editor.copilot"),
  require("plugins.editor.which-key"),
  -- snippets loader (luasnip custom snippets)
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
    end,
  },
}
