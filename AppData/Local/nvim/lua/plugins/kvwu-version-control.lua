return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
  },
  {
    "tpope/vim-fugitive",
    cond = function()
      return vim.fn.exists "g:vscode" == 0 and vim.fn.glob ".git" ~= nil
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
    cond = require("kvwu-config").profiles.work,
    dependencies = {
      "tpope/vim-rhubarb",
      "tpope/vim-fugitive",
    },
  },
}
