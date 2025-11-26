local M = {}

local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" }

local function mason_path(pkg)
  local ok, registry = pcall(require, "mason-registry")
  if not ok or not registry.has_package(pkg) then return nil end
  local p = registry.get_package(pkg)
  if not p:is_installed() then p:install() end
  return p:get_install_path()
end

local function find_java_exec()
  if vim.env.JAVA_HOME and vim.fn.executable(vim.env.JAVA_HOME .. "/bin/java") == 1 then
    return vim.env.JAVA_HOME .. "/bin/java", vim.env.JAVA_HOME
  end
  local exe = vim.fn.exepath("java")
  if exe ~= "" then
    return exe, vim.fn.fnamemodify(exe, ":h:h") -- assume .../bin/java
  end
  return nil, nil
end

local function find_root()
  local root = require("jdtls.setup").find_root(root_markers)
  if root ~= "" then return root end
  return vim.loop.cwd()
end

function M.build_cmd()
  local java_exec, java_home = find_java_exec()
  if not java_exec then return nil, "java executable not found (set JAVA_HOME or install JDK 17/21)" end

  local jdt_path = mason_path("jdtls")
  if not jdt_path then return nil, "jdtls not installed (install via :Mason)" end
  local launcher = vim.fn.glob(jdt_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher == "" then return nil, "jdtls launcher jar not found" end
  local sys = vim.loop.os_uname().sysname
  local config_dir = jdt_path .. "/config_linux"
  if sys == "Darwin" then config_dir = jdt_path .. "/config_mac" end
  if sys:match("Windows") then config_dir = jdt_path .. "/config_win" end

  local runtime = java_home and { name = "Java", path = java_home } or nil
  local workspace = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local root_dir = find_root()

  local bundles = {}
  for _, name in ipairs({ "java-debug-adapter", "java-test" }) do
    local path = mason_path(name)
    if path then
      for _, jar in ipairs(vim.split(vim.fn.glob(path .. "/extension/server/*.jar"), "\n")) do
        if jar ~= "" then table.insert(bundles, jar) end
      end
    end
  end

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

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = {
      java = {
        configuration = runtime and { runtimes = { runtime } } or nil,
        format = { enabled = false }, -- use conform with google-java-format
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

local function notify(level, msg)
  vim.notify("JDTLS: " .. msg, level)
end

function M.start(force)
  local ok, cfg = pcall(M.build_cmd)
  if not ok then
    notify(vim.log.levels.WARN, tostring(cfg))
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
  if force then
    notify(vim.log.levels.INFO, "(re)starting jdtls")
  end
  require("jdtls").start_or_attach(cfg)
end

function M.status()
  local java_exec = find_java_exec()
  local msgs = {}
  table.insert(msgs, "java exec: " .. (java_exec or "not found"))
  local jdt_path = mason_path("jdtls")
  table.insert(msgs, "jdtls path: " .. (jdt_path or "not installed"))
  notify(vim.log.levels.INFO, table.concat(msgs, " | "))
end

return M
