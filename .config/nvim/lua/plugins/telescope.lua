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
        file_ignore_patterns = { "node_modules", ".git", "dist", "build" },
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
