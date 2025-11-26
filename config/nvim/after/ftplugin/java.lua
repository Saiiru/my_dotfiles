local bootstrap = require("jdtls.jdtls_bootstrap")

if vim.b.jdtls_setup_done then return end

local function setup_with_retry()
  bootstrap.wait_for_mason_registry(function()
    if not bootstrap.is_mason_package_installed("jdtls") then
      vim.notify("[Java] JDTLS not installed. Install via :Mason → jdtls", vim.log.levels.WARN)
      return
    end
    local ok, err = pcall(function()
      bootstrap.setup_jdtls(vim.api.nvim_get_current_buf())
    end)
    if ok then
      vim.b.jdtls_setup_done = true
    else
      vim.notify("[Java] JDTLS setup failed: " .. tostring(err), vim.log.levels.ERROR)
    end
  end)
end

setup_with_retry()

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.textwidth = 120
