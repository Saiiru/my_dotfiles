local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },          -- core (plenary, tmux-nav)
    { import = "plugins.ui" },       -- UI/tema/statusline
    { import = "plugins.lsp" },      -- LSP/cmp/format/lint
    { import = "plugins.editor" },   -- treesitter, oil, telescope, mini, snacks
    { import = "plugins.git" },      -- git extras
    { import = "plugins.tools" },    -- utilitários (dap, sessions, todo, etc.)
  },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})
