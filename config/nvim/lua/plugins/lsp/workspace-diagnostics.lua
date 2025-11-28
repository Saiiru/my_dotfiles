---@type LazySpec
-- Workspace-wide diagnostics without noise
return {
  {
    "artemave/workspace-diagnostics.nvim",
    lazy = true,
    opts = {
      filetypes = {
        "java",
        "javascript",
        "typescript",
        "typescriptreact",
        "lua",
        "go",
        "python",
        "json",
        "yaml",
        "dockerfile",
        "groovy",
      },
    },
  },
}
