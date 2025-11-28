---@type LazySpec
-- Java LSP/DAP setup: runtime wiring happens in after/ftplugin/java.lua via jdtls_bootstrap
-- Keep the plugin available for commands and dependencies, but avoid double init.
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function() end,
  },
}
