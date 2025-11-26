-- Leader must be set before plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw banner (keep netrw available for fallback)
vim.g.netrw_banner = 0

-- UI
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.background = "dark"
vim.opt.winblend = 0
vim.opt.pumblend = 10

-- Indentation defaults (language-specific overrides live in ftplugin)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- Backup/undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("state") .. "/undodir"
vim.opt.undofile = true

-- Performance
vim.opt.updatetime = 50
vim.opt.timeoutlen = 400

-- Folding (for nvim-ufo)
vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "0"

-- Misc
vim.opt.clipboard:append("unnamedplus")
vim.opt.isfname:append("@-@")
vim.opt.mouse = "a"
