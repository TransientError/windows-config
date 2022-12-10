local kvwu_telescope = {}

function kvwu_telescope.setup(use, not_vscode)
  use {
    "nvim-telescope/telescope.nvim",
    cond = not_vscode,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local builtin = require "telescope.builtin"
      vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
      vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>,", builtin.buffers, {})
      vim.keymap.set("n", "<leader>ha", builtin.help_tags, {})
    end,
  }
  use {
    "nvim-telescope/telescope-project.nvim",
    config = function()
      local telescope = require "telescope"
      telescope.load_extension "project"
      vim.keymap.set("n", "<leader>pp", telescope.extensions.project.project)
    end,
    after = { "telescope.nvim" },
  }
end

return kvwu_telescope
