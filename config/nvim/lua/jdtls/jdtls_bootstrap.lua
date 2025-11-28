-- DRAGON-OPS JDTLS Bootstrap System v3.0
-- Bulletproof initialization with Mason registry resilience

local M = {}

-- Configuration constants
local JDTLS_WORKSPACE_BASE = vim.fn.stdpath("data") .. "/jdtls-workspace"
local MASON_PACKAGES = vim.fn.stdpath("data") .. "/mason/packages"

---Find Eclipse JDTLS launcher JAR
---@return string|nil
function M.find_launcher()
  local jdtls_path = MASON_PACKAGES .. "/jdtls"
  if vim.fn.isdirectory(jdtls_path) == 0 then return nil end
  local plugins_path = jdtls_path .. "/plugins"
  local launchers = vim.fn.glob(plugins_path .. "/org.eclipse.equinox.launcher_*.jar", false, true)
  return (#launchers > 0) and launchers[1] or nil
end

---Get Java home directory (JAVA_HOME > mise > system defaults)
---@return string
function M.get_java_home()
  local java_home = vim.env.JAVA_HOME
  if java_home and vim.fn.isdirectory(java_home) == 1 then return java_home end
  if vim.fn.executable("mise") == 1 then
    -- prefer modern JDKs first
    local candidates = { "java@21", "java@17", "java" }
    for _, ver in ipairs(candidates) do
      local handle = io.popen(string.format("mise where %s 2>/dev/null", ver))
      if handle then
        local mise_java = handle:read("*a"):gsub("%s+$", "")
        handle:close()
        if mise_java ~= "" and vim.fn.isdirectory(mise_java) == 1 then
          return mise_java
        end
      end
    end
  end
  local system_paths = {
    "/usr/lib/jvm/java-21-openjdk",
    "/usr/lib/jvm/java-17-openjdk",
    "/usr/lib/jvm/default",
  }
  for _, path in ipairs(system_paths) do
    if vim.fn.isdirectory(path) == 1 then return path end
  end
  return ""
end

---Workspace dir per project
function M.get_workspace_dir()
  local project_root = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = JDTLS_WORKSPACE_BASE .. "/" .. project_root
  vim.fn.mkdir(workspace_dir, "p")
  return workspace_dir
end

---Load debug/test bundles
function M.load_bundles()
  local bundles = {}
  local java_debug_path = MASON_PACKAGES .. "/java-debug-adapter/extension/server"
  if vim.fn.isdirectory(java_debug_path) == 1 then
    vim.list_extend(bundles, vim.fn.glob(java_debug_path .. "/com.microsoft.java.debug.plugin-*.jar", false, true))
  end
  local java_test_path = MASON_PACKAGES .. "/java-test/extension/server"
  if vim.fn.isdirectory(java_test_path) == 1 then
    vim.list_extend(bundles, vim.fn.glob(java_test_path .. "/*.jar", false, true))
  end
  return bundles
end

function M.is_mason_package_installed(package_name)
  return vim.fn.isdirectory(MASON_PACKAGES .. "/" .. package_name) == 1
end

function M.wait_for_mason_registry(callback)
  local max_attempts, attempt = 10, 0
  local function check()
    attempt = attempt + 1
    local ok, registry = pcall(require, "mason-registry")
    if ok and registry.refresh then
      callback()
      return
    end
    if attempt < max_attempts then
      vim.defer_fn(check, 100)
    else
      vim.notify("[JDTLS] Mason registry timeout. Use :JdtlsStart to retry.", vim.log.levels.WARN)
    end
  end
  check()
end

---Setup JDTLS
function M.setup_jdtls(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not M.is_mason_package_installed("jdtls") then
    vim.notify("[JDTLS] Not installed. Run :Mason and install jdtls", vim.log.levels.ERROR)
    return
  end

  local launcher = M.find_launcher()
  if not launcher then
    vim.notify("[JDTLS] Launcher JAR not found. Reinstall jdtls via :Mason", vim.log.levels.ERROR)
    return
  end

  local java_home = M.get_java_home()
  local workspace_dir = M.get_workspace_dir()
  local bundles = M.load_bundles()
  local jdtls_config = MASON_PACKAGES .. "/jdtls/config_linux"

  local cmd = {
    java_home ~= "" and (java_home .. "/bin/java") or "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", jdtls_config,
    "-data", workspace_dir,
  }

  local config = {
    cmd = cmd,
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
          favoriteStaticMembers = {
            "org.junit.Assert.*",
            "org.junit.jupiter.api.Assertions.*",
            "org.mockito.Mockito.*",
          },
          filteredTypes = { "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*" },
        },
        sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
        codeGeneration = {
          toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
          useBlocks = true,
        },
        inlayHints = { parameterNames = { enabled = "all" } },
        configuration = java_home ~= "" and {
          runtimes = {
            { name = "JavaSE-17", path = java_home },
          },
        } or nil,
      },
    },
    init_options = { bundles = bundles },
    on_attach = function(client, buf)
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      end
      local opts = { buffer = buf, silent = true }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>cjo", function() require('jdtls').organize_imports() end, opts)
      vim.keymap.set("n", "<leader>cjv", function() require('jdtls').extract_variable() end, opts)
      vim.keymap.set("v", "<leader>cjv", function() require('jdtls').extract_variable(true) end, opts)
      vim.keymap.set("n", "<leader>cjm", function() require('jdtls').extract_method() end, opts)
      vim.keymap.set("v", "<leader>cjm", function() require('jdtls').extract_method(true) end, opts)
      vim.notify("[JDTLS] Attached to buffer " .. buf, vim.log.levels.INFO)
    end,
    -- Capabilities: prefer cmp_nvim_lsp when available, otherwise fallback
    capabilities = (function()
      local base = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp = pcall(require, "cmp_nvim_lsp")
      if ok and cmp.default_capabilities then
        return cmp.default_capabilities(base)
      end
      return base
    end)(),
  }

  require("jdtls").start_or_attach(config)
end

return M
