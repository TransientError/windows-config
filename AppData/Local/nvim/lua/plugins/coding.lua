local utils = require "utils"

if utils.is_vscode() then
  return {}
end

return {
  {
    "stevearc/conform.nvim",
    event = "LazyFile",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format { async = true }
        end,
        desc = "Format with Conform",
      },
      {
        "<localleader>cf",
        function()
          require("conform").format { async = true }
        end,
        desc = "Format with Conform",
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
        python = { "black" },
        ocaml = { "ocamlformat" },
        lua = { "stylua" },
      },
      formatters = {
        stylua = {
          command = "stylua",
          prepend_args = { "--config-path", vim.fn.expand "~/.config/stylua.toml" },
        },
        csharpier = {
          command = "dotnet",
          args = { "csharpier", "format", "--write-stdout" },
          stdin = true,
        },
      },
    },
  },
  { "mattn/emmet-vim", ft = { "html", "xml" } },
  {
    "hedyhli/outline.nvim",
    keys = {
      { "<leader>oo", "<cmd>Outline<cr>", desc = "Toggle Outline" },
    },
    cmd = {
      "Outline",
    },
    opts = {
      providers = {
        priority = {
          "lsp",
          "markdown",
          "treesitter",
        },
      },
    },
    dependencies = {
      "epheien/outline-treesitter-provider.nvim",
    },
  },
  {
    "stevearc/aerial.nvim",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "AerialNavToggle" },
  },
}
