return {
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
  },
  {
    "p00f/nvim-ts-rainbow",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      local colors = require "material.colors"
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "lua" },
        highlight = {
          enable = true,
        },
        rainbow = {
          enable = true,
          colors = {
            colors.main.purple,
            colors.main.yellow,
            colors.main.blue,
            colors.main.cyan,
            colors.main.green,
            colors.main.orange,
            colors.main.red,
          },
        },
      }
      vim.treesitter.language.register('xml', 'html')
    end,
  }
}

