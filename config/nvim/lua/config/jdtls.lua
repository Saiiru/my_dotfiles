local M = {}

-- Adapted from user's reference configuration for a predictable jdtls bootstrap.

local function get_jdtls()
  local mason_registry = require("mason-registry")
  if not mason_registry.has_package("jdtls") then
    return nil, nil, nil, "jdtls not installed (install via :Mason)"
  end
  local jdtls = mason_registry.get_package("jdtls")
  local jdtls_path = jdtls:get_install_path()
  local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher == "" then return nil, nil, nil, "launcher jar not found" end
  local system = "linux"
  if vim.loop.os_uname().sysname == "Darwin" then system = "mac" end
  local config = jdtls_path .. "/config_" .. system
  local lombok = jdtls_path .. "/lombok.jar"
  return launcher, config, lombok
end

local function get_bundles()
  local mason_registry = require("mason-registry")
  local bundles = {}

  if mason_registry.has_package("java-debug-adapter") then
    local pkg = mason_registry.get_package("java-debug-adapter")
    local path = pkg:get_install_path()
    table.insert(bundles, vim.fn.glob(path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1))
  end

  if mason_registry.has_package("java-test") then
    local pkg = mason_registry.get_package("java-test")
    local path = pkg:get_install_path()
    vim.list_extend(bundles, vim.split(vim.fn.glob(path .. "/extension/server/*.jar", 1), "\n"))
  end

  return bundles
end

local function get_workspace()
  local home = vim.env.HOME or vim.fn.expand("~")
  local workspace_path = home .. "/code/workspace/"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  return workspace_path .. project_name
end

local function java_keymaps(bufnr)
  vim.cmd("command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)")
  vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
  vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
  vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map('n', '<leader>Jo', function() require('jdtls').organize_imports() end, "Java Organize Imports")
  map('n', '<leader>Jv', function() require('jdtls').extract_variable() end, "Java Extract Variable")
  map('v', '<leader>Jv', function() require('jdtls').extract_variable(true) end, "Java Extract Variable (v)")
  map('n', '<leader>JC', function() require('jdtls').extract_constant() end, "Java Extract Constant")
  map('v', '<leader>JC', function() require('jdtls').extract_constant(true) end, "Java Extract Constant (v)")
  map('n', '<leader>Jt', function() require('jdtls').test_nearest_method() end, "Java Test Method")
  map('v', '<leader>Jt', function() require('jdtls').test_nearest_method(true) end, "Java Test Method (v)")
  map('n', '<leader>JT', function() require('jdtls').test_class() end, "Java Test Class")
  map('n', '<leader>Ju', function() require('jdtls').update_project_config() end, "Java Update Config")
end

function M.setup_jdtls()
  local jdtls = require("jdtls")
  local launcher, os_config, lombok, err = get_jdtls()
  if not launcher then
    vim.notify("JDTLS: " .. (err or "missing"), vim.log.levels.WARN)
    return
  end

  local workspace_dir = get_workspace()
  local bundles = get_bundles()
  local root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' })

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = false

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. lombok,
    '-jar', launcher,
    '-configuration', os_config,
    '-data', workspace_dir,
  }

  local settings = {
    java = {
      format = { enabled = false }, -- use conform/google-java-format externally
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      saveActions = { organizeImports = true },
      sources = { organizeImports = { starThreshold = 9999, staticThreshold = 9999 } },
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
      configuration = { updateBuildConfiguration = "interactive" },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
    }
  }

  local init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  local on_attach = function(client, bufnr)
    java_keymaps(bufnr)
    require('jdtls.dap').setup_dap()
    require('jdtls.dap').setup_dap_main_class_configs()
    local ih_ok, ih = pcall(require, "inlay-hints")
    if ih_ok then ih.on_attach(client, bufnr) end
  end

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = settings,
    capabilities = capabilities,
    init_options = init_options,
    on_attach = on_attach,
  }

  jdtls.start_or_attach(config)
end

return M
