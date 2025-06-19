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
      "ggandor/leap.nvim",
      "s1n7ax/nvim-window-picker",
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
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = true,
        },
      },
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
  {
    "ggandor/leap.nvim",
    lazy = false,
    init = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set({ "n" }, "S", "<Plug>(leap-from-window)")
      vim.keymap.set({ "x", "o" }, "r", function()
        require("leap.remote").action()
      end)
      vim.keymap.set({ "n", "x", "o" }, "R", function()
        require("leap.treesitter").select()
      end)
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
    end,
  },
  {
    "cbochs/portal.nvim",
    keys = {
      {
        "<leader>bL",
        "<cmd>Portal jumplist backward<CR>",
        mode = { "n" },
        desc = "Portal: Jump to last location",
      },
      {
        "<leader>bH",
        "<cmd>Portal jumplist forward<CR>",
        mode = { "n" },
        desc = "Portal: Jump to next location",
      },
    },
  },
  {
    "cbochs/grapple.nvim",
    event = "VeryLazy",
    opts = {
      scope = "git_branch"
    },
    keys = {
      { "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
      { "<C-s>", "<cmd>Grapple toggle<cr>", desc = "Toggle tag" },
      { "H", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
      { "L", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
    },
    config = function(_, opts)
      require("grapple").setup(opts)
      require("telescope").load_extension "grapple"
      vim.keymap.set("n", ";", "<Cmd>Telescope grapple tags<CR>", { desc = "Grapple: Search tags" })
    end,
  },
}
