local utils = require "utils"
if utils.is_vscode() then
  return {}
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "ggandor/leap.nvim"
    },
    lazy = false,
    opts = {
      filesystem = {
        bind_to_cwd = true,
      },
      window = {
        mappings = {
          ["l"] = "set_root",
          ["s"] = function(state)
            require("leap").leap {
              target_windows = { vim.api.nvim_get_current_win() },
            }
          end,
          ["S"] = function(state)
            require("leap").leap {
              target_windows = { require("leap.util").get_enterable_windows() },
            }
          end,
          ["v"] = "open_vsplit",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.keymap.set("n", "<leader>op", "<Cmd>Neotree toggle<CR>", { desc = "NeoTree: Toggle" })
    end,
  },
  {
    "brenton-leighton/multiple-cursors.nvim",
    opts = {}, -- This causes the plugin setup function to be called
    keys = {
      { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
      { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move down" },

      { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" }, desc = "Add or remove cursor" },

      { "<M-d>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    cmd = { "Yazi" },
    keys = { { "<leader>y", "<Cmd>Yazi<CR>", mode = { "n", "v" }, desc = "Yazi: Open" } },
    opts = {
      open_for_directories = true,
    },
    cond = utils.is_neovide,
  },
}
