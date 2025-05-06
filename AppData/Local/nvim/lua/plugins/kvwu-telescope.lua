return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    keys = function()
      local builtin = require "telescope.builtin"
      return {
        { "<leader>pf", builtin.find_files },
        { "<leader>fr", builtin.oldfiles },
        { "<leader>,", builtin.buffers },
        { "<leader>ha", builtin.help_tags },
        "<leader>/",
      }
    end,
    config = function()
      local telescope = require "telescope"
      telescope.load_extension "live_grep_args"

      telescope.setup {
        extensions = {
          live_grep_args = {
            mappings = {
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
              },
            },
          },
        },
      }

      vim.keymap.set("n", "<leader>/", telescope.extensions.live_grep_args.live_grep_args, {})
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    keys = "<leader>pp",
    config = function()
      local telescope = require "telescope"
      telescope.load_extension "project"
      vim.keymap.set("n", "<leader>pp", telescope.extensions.project.project)
    end,
  },
}
