local jdt = require("utils.jdtls_bootstrap")

-- Auto start/attach JDTLS when entering Java buffers
jdt.start()

vim.api.nvim_create_user_command("JdtlsStart", function()
  jdt.start(true)
end, { desc = "(Re)start JDTLS" })

vim.api.nvim_create_user_command("JdtlsStatus", function()
  jdt.status()
end, { desc = "Show JDTLS start diagnostics" })
