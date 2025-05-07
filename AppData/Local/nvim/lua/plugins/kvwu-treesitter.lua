local utils = require "utils"
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cond = utils.vscode,
    opts = {
      ensure_installed = { "lua" },
      sync_install = false,
      auto_install = false,
      ignore_install = {},
      modules = {},
      highlight = {
        enable = true,
      },
    },
    config = function()
      vim.treesitter.language.register("xml", "html")
    end,
  },
}
