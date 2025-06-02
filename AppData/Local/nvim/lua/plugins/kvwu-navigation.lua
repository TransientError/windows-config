local utils = require "utils"

return {
  {
    "nvim-tree/nvim-tree.lua",
    cond = utils.not_vscode,
    enabled = false,
    opts = {
      update_focused_file = {
        enable = true,
      },
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set("n", "l", api.tree.change_root_to_node, opts "cd")
      end,
    },
    cmd = { "NvimTreeToggle" },
    keys = { { "<leader>op", ":NvimTreeToggle<CR>", mode = { "n", "v" } } },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    opts = {
      filesystem = {
        bind_to_cwd = true,
      },
      window = {
        mappings = {
          ["l"] = "set_root",
          ["s"] = {
            function(state)
              utils.flash_jump()
            end,
          },
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
    keys = {
      {
        "s",
        function()
          utils.flash_jump()
        end,
        mode = { "n", "x", "o" },
        desc = "Flash",
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        mode = { "n" },
        desc = "Flash Treesitter",
      },
      {
        "r",
        function()
          require("flash").remote {
            jump = {
              autojump = true,
            },
          }
        end,
        mode = { "o", "x" },
        desc = "Flash Remote",
      },
      {
        "R",
        function()
          require("flash").treesitter_search()
        end,
        mode = { "o", "x" },
        desc = "Flash Treesitter Search",
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
}
