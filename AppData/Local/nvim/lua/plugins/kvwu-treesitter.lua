local utils = require "utils"
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cond = utils.not_vscode,
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
    main = "nvim-treesitter.configs",
  },
}
