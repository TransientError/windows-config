local kvwu_treesitter = {}

function kvwu_treesitter.setup(use, not_vscode)
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    cond = not_vscode,
    module = { "nvim-treesitter.query", "nvim-treesitter.configs" },
  }
  use {
    "p00f/nvim-ts-rainbow",
    cond = not_vscode,
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
end

return kvwu_treesitter
