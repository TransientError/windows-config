return {
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "lua" },
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true,
        },
      }
      vim.treesitter.language.register('xml', 'html')
    end,
  },
}

