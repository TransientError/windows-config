local utils = require "utils"

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
  { "tpope/vim-surround", event = "LazyFile" },
  { "mattn/emmet-vim", ft = { "html", "xml" } },
  { "vim-scripts/ReplaceWithRegister", event = "LazyFile" },
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", "<Plug>(leap-forward)" },
      { "S", "<Plug>(leap-backward)" },
      { "gs", "<Plug>(leap-from-window)" },
    },
  },
  {
    "folke/which-key.nvim",
    cond = utils.vscode,
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    opts = {},
    event = "LazyFile",
  },
  {
    "chentoast/marks.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "Pocco81/auto-save.nvim",
    event = "VeryLazy",
    opts = {
      condition = function(buf)
        local path = vim.fn.expand "%:p"
        local config = vim.fn.stdpath "config"
        local is_in_config = string.find(path, "^" .. config) ~= nil
        return vim.fn.getbufvar(buf, "&modifiable") == 1 and not is_in_config
      end,
    },
  },
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_patterns = { ".git", "=nvim", "=work", "=utils", "*.sln", "*.csproj" }
    end,
  },
  { "windwp/nvim-ts-autotag", event = "LazyFile" },
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "b0o/SchemaStore",
    ft = { "json", "jsonc", "yaml" },
  },
  {
    "github/copilot.vim",
    event = "LazyFile",
    cmd = { "Copilot" },
    keys = {
      { "<right>", 'copilot#Accept("\\<right>")', mode = "i", expr = true, replace_keycodes = false },
    },
  },
}
