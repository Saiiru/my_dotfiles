local M = {}

local function mason_path(pkg)
  local ok, registry = pcall(require, "mason-registry")
  if not ok or not registry.has_package(pkg) then return nil end
  local p = registry.get_package(pkg)
  if not p:is_installed() then p:install() end
  return p:get_install_path()
end

function M.build_cmd()
  local jdt_path = mason_path("jdtls")
  if not jdt_path then return nil, "jdtls not installed" end
  local launcher = vim.fn.glob(jdt_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher == "" then return nil, "jdtls launcher jar not found" end
  local sys = vim.loop.os_uname().sysname
  local config_dir = jdt_path .. "/config_linux"
  if sys == "Darwin" then config_dir = jdt_path .. "/config_mac" end
  if sys:match("Windows") then config_dir = jdt_path .. "/config_win" end

  local java_home = vim.env.JAVA_HOME
  local runtime = java_home and { name = "Java", path = java_home } or nil
  local java_exec = vim.fn.exepath("java")
  if java_exec == "" then return nil, "java executable not found in PATH; set JAVA_HOME or install JDK 17/21" end

  local workspace = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  local cmd = {
    java_exec,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "-javaagent:" .. jdt_path .. "/lombok.jar",
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", workspace,
  }

  local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
  local root_dir = require("jdtls.setup").find_root(root_markers)
  if root_dir == "" then root_dir = vim.fn.getcwd() end

  local bundles = {}
  for _, name in ipairs({ "java-debug-adapter", "java-test" }) do
    local path = mason_path(name)
    if path then
      for _, jar in ipairs(vim.split(vim.fn.glob(path .. "/extension/server/*.jar"), "\n")) do
        if jar ~= "" then table.insert(bundles, jar) end
      end
    end
  end

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = {
      java = {
        configuration = runtime and { runtimes = { runtime } } or nil,
        format = { enabled = false },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        sources = { organizeImports = { starThreshold = 999, staticStarThreshold = 999 } },
        inlayHints = {
          parameterNames = { enabled = "all", exclusions = { "this" } },
        },
      },
    },
    init_options = { bundles = bundles },
  }
  return config
end

function M.start()
  local ok, cfg = pcall(M.build_cmd)
  if not ok then
    vim.notify("JDTLS: " .. tostring(cfg), vim.log.levels.WARN)
    return
  end
  if not cfg then return end
  cfg.on_attach = function(client, bufnr)
    local ih_ok, ih = pcall(require, "inlay-hints")
    if ih_ok then ih.on_attach(client, bufnr) end
    local jdtls = require("jdtls")
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    jdtls.dap.setup_dap_main_class_configs()
  end
  require("jdtls").start_or_attach(cfg)
end

return M
