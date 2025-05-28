local utils = require "utils"
local config = require "kvwu-config"

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    cond = utils.not_vscode,
  },
  {
    "cedarbaum/fugitive-azure-devops.vim",
    cond = config.profiles.work,
    dependencies = {
      "tpope/vim-rhubarb",
      "tpope/vim-fugitive",
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = {
      {
        "<leader>gg",
        "<cmd>Neogit<cr>",
        silent = true,
      },
    },
    opts = function()
      local colors = require "material.colors"
      return {
        highlight = {
          bg_green = colors.editor.bg,
          bg_red = colors.editor.bg,
        },
      }
    end,
  },
}
