return {
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
    lazy = false,
    opts = { transparent = true, italic_comments = true, borderless_telescope = true },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      vim.cmd.colorscheme("cyberdream")

      -- Batman/neo-gotham overrides: high-contrast comments & hints without eye strain
      local hl = vim.api.nvim_set_hl
      local green = "#7CFF00"
      local soft_green = "#6bd968"
      local bg_dim = "NONE"

      -- Comments & docs
      hl(0, "Comment", { fg = green, italic = true, bg = bg_dim })
      hl(0, "@comment", { fg = green, italic = true, bg = bg_dim })
      hl(0, "@comment.documentation", { fg = green, italic = true, bg = bg_dim })

      -- Inlay hints readable on transparent background
      hl(0, "LspInlayHint", { fg = soft_green, bg = bg_dim, italic = true })

      -- Treesitter tweaks for code readability
      hl(0, "@keyword", { fg = "#FF5555", italic = true, bold = false })  -- punchy red keywords
      hl(0, "@function", { fg = "#00CFFF", bold = true })
      hl(0, "@string", { fg = "#9AE66E" })
      hl(0, "@variable", { fg = "#E6E6E6" })
      hl(0, "CursorLine", { bg = "#141824" })
      hl(0, "Visual", { bg = "#233040" })

      -- Statusline / UI accents to match transparent background
      hl(0, "StatusLine", { bg = bg_dim, fg = "#C8D0E0" })
      hl(0, "StatusLineNC", { bg = bg_dim, fg = "#5c6773" })
      hl(0, "WinSeparator", { fg = "#2a2f3a", bg = bg_dim })
      hl(0, "FloatBorder", { fg = "#FF6EC7", bg = bg_dim })
      hl(0, "NormalFloat", { bg = bg_dim })
      hl(0, "Pmenu", { bg = "#111622", fg = "#d0d7e4" })
      hl(0, "PmenuSel", { bg = "#233040", fg = "#FF6EC7", bold = true })
      hl(0, "TelescopeSelection", { bg = "#233040", fg = "#E6E6E6", bold = true })
    end,
  },
}
