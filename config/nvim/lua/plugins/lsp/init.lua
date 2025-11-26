return {
  require("plugins.lsp.blink"),
  require("plugins.lsp.formatting"),
  require("plugins.lsp.linting"),
  require("plugins.lsp.tailwind-tools"),
  require("plugins.lsp.emmet"),
  require("plugins.lsp.gopher"),
  require("plugins.lsp.diagnostics"),
  require("plugins.lsp.inlay-hints"),
  require("plugins.lsp.java"),
  { import = "plugins.lsp.config" }, -- mason + lspconfig specs
}
