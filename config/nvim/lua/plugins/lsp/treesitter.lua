-- Enhanced Treesitter setup with resilient jsonc source and batman-friendly defaults
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      opts.install = opts.install or {}
      opts.install.prefer_git = true -- force git clone to avoid tarball 403

      -- Add commonly-used parsers (temporarily removing jsonc due to GitHub 403)
      local extra = { "json", "lua", "bash", "python", "java", "go", "javascript", "typescript", "tsx", "yaml", "dockerfile", "groovy" }
      for _, lang in ipairs(extra) do
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false

      opts.incremental_selection = opts.incremental_selection or {
        enable = true,
        keymaps = { init_selection = "gnn", node_incremental = "grn", scope_incremental = "grc", node_decremental = "grm" },
      }

      opts.indent = opts.indent or { enable = true, disable = { "yaml" } }

      return opts
    end,
  },
}
