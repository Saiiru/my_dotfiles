local M = {}

local function mason_path(pkg)
  local ok, registry = pcall(require, "mason-registry")
  if not ok or not registry.has_package(pkg) then return nil end
  local p = registry.get_package(pkg)
  if not p:is_installed() then p:install() end
  return p:get_install_path()
end

local function workspace_dir()
  local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  return vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project
end

local function system_config(jdtls_path)
  local sys = vim.loop.os_uname().sysname
  if sys == "Darwin" then return jdtls_path .. "/config_mac" end
  if sys:match("Windows") then return jdtls_path .. "/config_win" end
  return jdtls_path .. "/config_linux"
end

local function java_bundles()
  local bundles = {}
  for _, name in ipairs({ "java-debug-adapter", "java-test" }) do
    local path = mason_path(name)
    if path then
      for _, jar in ipairs(vim.split(vim.fn.glob(path .. "/extension/server/*.jar"), "\n")) do
        if jar ~= "" then table.insert(bundles, jar) end
      end
    end
  end
  return bundles
end

function M.setup()
  local jdtls_path = mason_path("jdtls")
  if not jdtls_path then
    vim.notify("JDTLS: install via :Mason", vim.log.levels.WARN)
    return
  end
  local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher == "" then
    vim.notify("JDTLS: launcher jar not found", vim.log.levels.ERROR)
    return
  end

  local java = vim.fn.exepath("java")
  if java == "" then
    vim.notify("JDTLS: java not found in PATH (set JAVA_HOME)", vim.log.levels.ERROR)
    return
  end

  local config = {
    cmd = {
      java,
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-javaagent:" .. jdtls_path .. "/lombok.jar",
      "-jar", launcher,
      "-configuration", system_config(jdtls_path),
      "-data", workspace_dir(),
    },
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
    settings = {
      java = {
        format = { enabled = false },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        saveActions = { organizeImports = true },
        sources = { organizeImports = { starThreshold = 9999, staticThreshold = 9999 } },
        referencesCodeLens = { enabled = true },
        inlayHints = { parameterNames = { enabled = "all" } },
      },
    },
    init_options = {
      bundles = java_bundles(),
      extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
    },
    on_attach = function(client, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map('n', '<leader>Jo', function() require('jdtls').organize_imports() end, "Java Organize Imports")
      map('n', '<leader>Jv', function() require('jdtls').extract_variable() end, "Java Extract Var")
      map('v', '<leader>Jv', function() require('jdtls').extract_variable(true) end, "Java Extract Var (v)")
      map('n', '<leader>JC', function() require('jdtls').extract_constant() end, "Java Extract Const")
      map('v', '<leader>JC', function() require('jdtls').extract_constant(true) end, "Java Extract Const (v)")
      map('n', '<leader>Jt', function() require('jdtls').test_nearest_method() end, "Java Test Method")
      map('v', '<leader>Jt', function() require('jdtls').test_nearest_method(true) end, "Java Test Method (v)")
      map('n', '<leader>JT', function() require('jdtls').test_class() end, "Java Test Class")
      map('n', '<leader>Ju', function() require('jdtls').update_project_config() end, "Java Update Config")

      require('jdtls.dap').setup_dap()
      require('jdtls.dap').setup_dap_main_class_configs()
      local ok, ih = pcall(require, "inlay-hints")
      if ok then ih.on_attach(client, bufnr) end
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  }

  require("jdtls").start_or_attach(config)
end

return M
