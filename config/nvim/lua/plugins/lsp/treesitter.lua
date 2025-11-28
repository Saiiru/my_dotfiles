-- Enhanced Treesitter setup with resilient jsonc source and batman-friendly defaults
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}

      -- Add commonly-used parsers; keep jsonc but fetch from git to avoid 403 tarball errors
      local extra = { "jsonc", "json", "lua", "bash", "python", "java", "go", "javascript", "typescript", "tsx", "yaml", "dockerfile", "groovy" }
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

      -- Work around jsonc tarball 403 by forcing git source
      local ok, parsers = pcall(require, "nvim-treesitter.parsers")
      if ok and parsers.get_parser_configs then
        local configs = parsers.get_parser_configs()
        if configs and configs.jsonc then
          configs.jsonc.install_info.url = "https://github.com/tree-sitter/tree-sitter-jsonc"
          configs.jsonc.install_info.files = { "src/parser.c", "src/scanner.c" }
          configs.jsonc.install_info.branch = "master"
          configs.jsonc.install_info.requires_generate_from_grammar = false
        end
      end

      return opts
    end,
  },
}
