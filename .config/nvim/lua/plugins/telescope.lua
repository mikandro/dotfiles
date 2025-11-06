return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          ".git",
          "dist",
          "build",
          "vendor",        -- Go vendor directory
          "__pycache__",   -- Python cache
          "%.pyc",         -- Python bytecode
          ".venv",         -- Python venv
          "venv",          -- Python venv
          ".pytest_cache", -- Python pytest
          ".mypy_cache",   -- Python mypy
          ".ruff_cache",   -- Python ruff
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
    },
  },
}
