return {
  {
    "echasnovski/mini.surround",
    version = false,
    ---@type LazyKeysSpec[]
    keys = {
      { "ys", "", desc = "add surround" },
      { "ds", "", desc = "delete surround" },
      { "cs", "", desc = "replace surround" },
      {
        "S",
        function()
          require("mini.surround").add "visual"
        end,
        mode = { "v" },
        silent = true,
      },
    },
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
      },
    },
    config = function()
      vim.keymap.del("x", "ys")
    end,
  },
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
  { "mattn/emmet-vim", ft = { "html", "xml" } },
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
