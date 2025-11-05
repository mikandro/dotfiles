-- Options
local opt = vim.opt

-- General
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.mouse = "a" -- Enable mouse support
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.timeoutlen = 300

-- UI
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight current line
opt.signcolumn = "yes" -- Always show sign column
opt.termguicolors = true -- True color support
opt.scrolloff = 8 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.wrap = false -- Disable line wrap
opt.list = true -- Show some invisible characters
opt.listchars = { tab = "▸ ", trail = "·", nbsp = "_" }

-- Search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Don't ignore case with capitals
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Incremental search

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent (2 spaces for JS/TS)
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2
opt.smartindent = true -- Insert indents automatically
opt.shiftround = true -- Round indent

-- Splits
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10 -- Maximum number of entries in popup

-- Performance
opt.lazyredraw = true -- Don't redraw while executing macros
opt.ttyfast = true -- Fast terminal connection

-- Backup
opt.backup = false -- Don't create backup files
opt.writebackup = false
opt.swapfile = false -- Don't create swap files
