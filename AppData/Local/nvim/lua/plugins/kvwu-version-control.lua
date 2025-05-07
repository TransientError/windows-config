local utils = require "utils"
local config = require "kvwu-config"

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    cond = utils.vscode
  },
  {
    "tpope/vim-fugitive",
    cond = function()
      return utils.vscode() and vim.fn.glob ".git" ~= nil
    end,
    keys = {
      {
        "<leader>gg",
        ":Git<CR>",
      },
    },
    cmd = "Git",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fugitive",
        callback = function()
          vim.keymap.set("n", "pu", ":Git push<CR>", { noremap = true, buffer = true })
        end,
      })
    end,
  },
  {
    "cedarbaum/fugitive-azure-devops.vim",
    cond = config.profiles.work,
    dependencies = {
      "tpope/vim-rhubarb",
      "tpope/vim-fugitive",
    },
  },
}
