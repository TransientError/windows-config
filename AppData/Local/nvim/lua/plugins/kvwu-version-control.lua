local utils = require "utils"
local config = require "kvwu-config"

if utils.is_vscode() then
  return {}
end

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
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    opts = {
      default_mappings = false,
    },
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
      local Hydra = require "hydra"
      Hydra {
        name = "Git Conflict",
        mode = { "n" },
        body = "<leader>gc",
        heads = {
          { "h", "<Plug>(git-conflict-ours)", { desc = "Use ours" } },
          { "l", "<Plug>(git-conflict-theirs)", { desc = "Use theirs" } },
          { "b", "<Plug>(git-conflict-both)", { desc = "Use both" } },
          { "0", "<Plug>(git-conflict-none)", { desc = "Use neither" } },
          { "p", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" } },
          { "n", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" } },
          { "r", "<Plug>(git-conflict-reset)", { desc = "Reset conflict" } },
          { "<Esc>", nil, { exit = true, nowait = true } },
        },
      }
    end,
  },
}
