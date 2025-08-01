if require("utils").is_vscode() then
  return {}
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    keys = function()
      local builtin = require "telescope.builtin"
      local telescope = require "telescope"
      return {
        { "<leader>pf", builtin.find_files },
        { "<leader>fr", builtin.oldfiles },
        { "<leader>,", builtin.buffers },
        { "<leader>ha", builtin.help_tags },
        { "<leader>/", telescope.extensions.live_grep_args.live_grep_args },
        { "<leader>pp", telescope.extensions.project.project },
      }
    end,
    config = function()
      local telescope = require "telescope"
      telescope.load_extension "live_grep_args"
      telescope.load_extension "project"

      telescope.setup {
        defaults = {
          mappings = {
            n = {
              ["q"] = require("telescope.actions").close
            }
          }
        },
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
    end,
  },
}
