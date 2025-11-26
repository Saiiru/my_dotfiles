-- Universal Inlay Hints Toggle System
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints = { enabled = true }
      opts.servers = opts.servers or {}
      opts.servers.jdtls = opts.servers.jdtls or {}
      opts.servers.jdtls.settings = opts.servers.jdtls.settings or {}
      opts.servers.jdtls.settings.java = opts.servers.jdtls.settings.java or {}
      opts.servers.jdtls.settings.java.inlayHints = { parameterNames = { enabled = "all" } }

      opts.servers.ts_ls = opts.servers.ts_ls or {}
      opts.servers.ts_ls.settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      }

      opts.servers.gopls = opts.servers.gopls or {}
      opts.servers.gopls.settings = {
        gopls = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      }

      opts.servers.lua_ls = opts.servers.lua_ls or {}
      opts.servers.lua_ls.settings = {
        Lua = {
          hint = {
            enable = true,
            paramType = true,
            paramName = "All",
            semicolon = "SameLine",
            arrayIndex = "Enable",
          },
        },
      }
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>uh",
        function()
          local current = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
          vim.lsp.inlay_hint.enable(not current)
          vim.notify(string.format("[Inlay Hints] %s", current and "Disabled" or "Enabled"), vim.log.levels.INFO)
        end,
        desc = "Toggle Inlay Hints",
      },
    },
    config = function()
      vim.api.nvim_create_user_command("InlayHintsToggle", function()
        local current = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
        vim.lsp.inlay_hint.enable(not current)
        vim.notify(string.format("[Inlay Hints] %s", current and "Disabled" or "Enabled"), vim.log.levels.INFO)
      end, {})
      vim.api.nvim_create_user_command("InlayHintsEnable", function()
        vim.lsp.inlay_hint.enable(true)
      end, {})
      vim.api.nvim_create_user_command("InlayHintsDisable", function()
        vim.lsp.inlay_hint.enable(false)
      end, {})
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "cyberdream",
        callback = function()
          vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c6773", bg = "NONE", italic = true })
        end,
      })
    end,
  },
}
