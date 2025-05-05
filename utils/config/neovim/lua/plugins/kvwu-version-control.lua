return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
    cond = function() 
      return vim.fn.exists "g:vscode" == 0
    end,
  },
  {
    "tpope/vim-fugitive",
    cond = function()
      return vim.fn.exists "g:vscode" == 0 and vim.fn.glob ".git" ~= nil
    end,
    config = function()
      vim.keymap.set("n", "<leader>gg", ":Git<CR>")
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
    disable = not require("kvwu-config").profiles.work,
    dependencies = {
      "tpope/vim-rhubarb",
      "tpope/vim-fugitive",
    },
  }
}

