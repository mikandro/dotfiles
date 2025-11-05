-- Autocmds
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General settings group
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = general,
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "startuptime",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-format on save for specific filetypes
local format = augroup("Format", { clear = true })
autocmd("BufWritePre", {
  group = format,
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.json", "*.lua" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Set specific indentation for file types
local indent = augroup("Indent", { clear = true })
autocmd("FileType", {
  group = indent,
  pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact", "json", "lua", "yaml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Go back to last location when opening a file
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
