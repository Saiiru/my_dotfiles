---@type LazySpec
-- Java LSP/DAP setup via nvim-jdtls + Mason
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      require("jdtls.jdtls_setup").setup()
    end,
  },
}
