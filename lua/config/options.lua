-- Leader keys (MUST be set before lazy.nvim loads)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.shiftround = true
vim.opt.smartindent = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false -- lualine shows mode
vim.opt.laststatus = 3 -- global statusline
vim.opt.cmdheight = 0 -- hide command line when not in use
vim.opt.wrap = false
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.pumheight = 10
vim.opt.showcmd = true -- partial commands shown via %S in lualine
vim.opt.showcmdloc = "statusline" -- for %S in lualine

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen"

-- Files
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Timing
vim.opt.timeoutlen = 300
vim.opt.updatetime = 200

-- Completion (native Neovim 0.11+)
vim.opt.completeopt = "menu,menuone,noinsert,fuzzy"

-- Misc
vim.opt.confirm = true
vim.opt.fillchars = { fold = " ", diff = "╱", eob = " " }
vim.opt.formatoptions = "jcroqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.jumpoptions = "view"
vim.opt.linebreak = true
vim.opt.mouse = "a"
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5

-- Spelling (off by default)
vim.opt.spell = false
vim.opt.spelllang = { "en" }

-- Diagnostics disabled in init.lua VeryLazy callback to avoid loading
-- vim.diagnostic module at startup (~1.5ms saved)

-- Statusline time display (off by default, toggle with <leader>ut)
vim.g.show_time = false

-- Autoformat on save (toggle with <leader>uf)
vim.g.autoformat = true
