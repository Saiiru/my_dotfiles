return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    vim.api.nvim_create_user_command("JdtlsStart", function()
      local bootstrap = require("jdtls.jdtls_bootstrap")
      bootstrap.setup_jdtls(vim.api.nvim_get_current_buf())
    end, { desc = "Start/restart JDTLS server" })

    vim.api.nvim_create_user_command("JdtlsOrganizeImports", function()
      require("jdtls").organize_imports()
    end, { desc = "Organize Java imports" })

    vim.api.nvim_create_user_command("JdtlsUpdateConfig", function()
      require("jdtls").update_project_config()
      vim.notify("[JDTLS] Project configuration updated", vim.log.levels.INFO)
    end, { desc = "Reload JDTLS project configuration" })

    vim.api.nvim_create_user_command("JdtlsExtractVariable", function()
      require("jdtls").extract_variable()
    end, { desc = "Extract selection to variable", range = true })

    vim.api.nvim_create_user_command("JdtlsExtractMethod", function()
      require("jdtls").extract_method()
    end, { desc = "Extract selection to method", range = true })

    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>cj", group = "java" },
        { "<leader>cjo", "<Cmd>JdtlsOrganizeImports<CR>", desc = "Organize imports" },
        { "<leader>cju", "<Cmd>JdtlsUpdateConfig<CR>", desc = "Update config" },
        { "<leader>cjr", "<Cmd>JdtlsStart<CR>", desc = "Restart server" },
        { "<leader>cjv", "<Cmd>JdtlsExtractVariable<CR>", desc = "Extract variable", mode = { "n", "v" } },
        { "<leader>cjm", "<Cmd>JdtlsExtractMethod<CR>", desc = "Extract method", mode = { "n", "v" } },
      })
    end
  end,
}
