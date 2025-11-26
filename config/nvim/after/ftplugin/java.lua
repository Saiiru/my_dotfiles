local jdt = require("utils.jdtls_bootstrap")

-- Start/attach jdtls when entering a Java buffer
jdt.start()

vim.api.nvim_create_user_command("JdtlsStart", function()
  jdt.start()
end, {})
