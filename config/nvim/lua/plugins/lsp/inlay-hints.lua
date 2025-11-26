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
    -- fallback command if plugin commands fail
    vim.api.nvim_create_user_command("InlayHintsEnable", function()
      local client = vim.lsp.get_clients({ bufnr = 0 })[1]
      if client then ih.on_attach(client, vim.api.nvim_get_current_buf()) end
    end, {})
  end,
}
