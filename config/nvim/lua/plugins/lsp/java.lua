-- Java LSP/Debug/Test bootstrap via nvim-jdtls + Mason assets
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "williamboman/mason.nvim",
    },
    config = function()
      local ok, mason_registry = pcall(require, "mason-registry")
      if not ok then return end

      local function ensure_pkg(name)
        if not mason_registry.has_package(name) then return nil end
        local pkg = mason_registry.get_package(name)
        if not pkg:is_installed() then pkg:install() end
        return pkg
      end

      local jdtls_pkg = ensure_pkg("jdtls")
      if not jdtls_pkg or not jdtls_pkg.get_install_path then
        vim.notify("jdtls não instalado. Abra :Mason e instale.", vim.log.levels.WARN)
        return
      end

      local jdtls_path = jdtls_pkg:get_install_path()
      local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      if launcher == "" then
        vim.notify("Launcher do jdtls não encontrado", vim.log.levels.ERROR)
        return
      end
      local config_dir = jdtls_path .. "/config_linux"
      local uname = vim.loop.os_uname().sysname
      if uname == "Darwin" then config_dir = jdtls_path .. "/config_mac" end
      if uname:match("Windows") then config_dir = jdtls_path .. "/config_win" end

      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == "" then root_dir = vim.fn.getcwd() end

      local bundles = {}
      for _, name in ipairs({ "java-debug-adapter", "java-test" }) do
        local pkg = ensure_pkg(name)
        if pkg and pkg.get_install_path then
          local jar_glob = pkg:get_install_path() .. "/extension/server/*.jar"
          for _, jar in ipairs(vim.split(vim.fn.glob(jar_glob), "\n")) do
            if jar ~= "" then table.insert(bundles, jar) end
          end
        end
      end

      local java_home = vim.env.JAVA_HOME or ""

      local function start_jdtls()
        local config = {
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xms1g",
            "-javaagent:" .. jdtls_path .. "/lombok.jar",
            "-jar", launcher,
            "-configuration", config_dir,
            "-data", workspace_dir,
          },
          root_dir = root_dir,
          settings = {
            java = {
              configuration = java_home ~= "" and { runtimes = { { name = "Java", path = java_home } } } or nil,
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
          on_attach = function(client, bufnr)
            -- DAP
            require('jdtls').setup_dap({ hotcodereplace = 'auto' })
            require('jdtls.dap').setup_dap_main_class_configs()
            -- Inlay hints
            local ih_ok, ih = pcall(require, "inlay-hints")
            if ih_ok then ih.on_attach(client, bufnr) end
          end,
        }
        require("jdtls").start_or_attach(config)
      end

      -- auto start on FileType java
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = start_jdtls,
        group = vim.api.nvim_create_augroup("java-jdtls-autostart", { clear = true }),
      })

      -- manual command
      vim.api.nvim_create_user_command("JdtlsStart", start_jdtls, {})
    end,
  },
}
