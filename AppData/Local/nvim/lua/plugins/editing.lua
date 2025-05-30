local utils = require "utils"

local add = "gsa"
local delete = "gsd"
local replace = "gsr"

return {
  {
    "echasnovski/mini.surround",
    version = false,
    -- lazy = false,
    ---@type LazyKeysSpec[]
    keys = {
      { add, desc = "add surround" },
      { delete, desc = "delete surround" },
      { replace, desc = "replace surround" },
    },
    opts = {
      mappings = {
        add = add,
        delete = delete,
        replace = replace,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    cond = utils.not_vscode,
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
      }
    },
  },
  {
    "wellle/targets.vim",
    event = "LazyFile",
    init = function()
      vim.cmd [[
        autocmd User targets#mappings#user call targets#mappings#extend({
           \ 'a': {'argument': [{'o':'[({<[]', 'c':'[]}>)]', 's': ','}]}
           \ })
     ]]
    end,
  },
  { "mattn/emmet-vim", ft = { "html", "xml" }, cond = utils.not_vscode },
  {
    "windwp/nvim-autopairs",
    opts = {},
    event = "LazyFile",
  },
  {
    "gbprod/substitute.nvim",
    opts = {},
    keys = {
      {
        "gr",
        function()
          require("substitute").operator()
        end,
        mode = "n",
        noremap = true,
      },
    },
  },
}
