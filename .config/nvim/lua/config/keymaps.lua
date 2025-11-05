-- Keymaps
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move text up and down
keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Better indenting
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Clear search highlighting
keymap.set("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Save file
keymap.set("n", "<C-s>", ":w<CR>", opts)

-- Quit
keymap.set("n", "<leader>q", ":q<CR>", opts)
keymap.set("n", "<leader>Q", ":qa!<CR>", opts)

-- Buffer navigation
keymap.set("n", "<S-l>", ":bnext<CR>", opts)
keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
keymap.set("n", "<leader>bd", ":bdelete<CR>", opts)

-- Keep cursor centered when scrolling
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Keep search results centered
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- Paste without yanking
keymap.set("v", "p", '"_dP', opts)

-- Strip trailing whitespace
keymap.set("n", "<leader>ss", ":%s/\\s\\+$//e<CR>", { noremap = true, silent = true, desc = "Strip whitespace" })

-- Save as root (requires sudo)
keymap.set("n", "<leader>W", ":w !sudo tee % > /dev/null<CR>", { noremap = true, desc = "Save as root" })
