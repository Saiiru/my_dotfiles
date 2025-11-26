return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.groovyls = {
        cmd = { "groovy-language-server" },
        filetypes = { "groovy", "Jenkinsfile" },
        root_dir = function(fname)
          local root = vim.fs.dirname(vim.fs.find({ "Jenkinsfile", ".git" }, { upward = true })[1])
          return root or vim.loop.cwd()
        end,
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "groovy")
    end,
  },
}
