return {
  "MysticalDevil/inlay-hints.nvim",
  event = "LspAttach",
  opts = {
    commands = { enable = true },
    autocmd = { enable = true },
    highlight = "Comment",
    eol = { right_align = false },
  },
  config = function(_, opts)
    local ih = require("inlay-hints")
    ih.setup(opts)
    vim.api.nvim_create_user_command("InlayHintsEnable", function()
      local client = vim.lsp.get_clients({ bufnr = 0 })[1]
      if client then ih.on_attach(client, vim.api.nvim_get_current_buf()) end
    end, {})
    vim.api.nvim_create_user_command("InlayHintsDisable", function()
      pcall(vim.lsp.inlay_hint.enable, false, { bufnr = 0 })
    end, {})
    vim.api.nvim_create_user_command("InlayHintsToggle", function()
      local buf = 0
      local enabled = pcall(vim.lsp.inlay_hint.is_enabled, buf) and vim.lsp.inlay_hint.is_enabled(buf)
      pcall(vim.lsp.inlay_hint.enable, not enabled, { bufnr = buf })
    end, {})
  end,
}
