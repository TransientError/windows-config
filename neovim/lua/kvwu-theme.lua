local kvwu_theme = {}

function kvwu_theme.setup(use, not_vscode)
  use {
    "marko-cerovac/material.nvim",
    cond = not_vscode,
    config = require("kvwu-material").setup,
    after = "lualine.nvim",
    module = "material",
  }
  use {
    "nvim-lualine/lualine.nvim",
    config = require("kvwu-lualine").setup,
    cond = not_vscode,
  }
end

return kvwu_theme
