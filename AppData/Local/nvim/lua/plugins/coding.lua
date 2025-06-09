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
        csharp = { "csharpier" },
        python = { "black" },
        ocaml = { "ocamlformat" },
        lua = { "stylua" },
      },
      formatters = {
        stylua = {
          command = "stylua",
          prepend_args = { "--config-path", vim.fn.expand "~/.config/stylua.toml" },
        },
      },
    },
  },
  { "mattn/emmet-vim", ft = { "html", "xml" } },
}
