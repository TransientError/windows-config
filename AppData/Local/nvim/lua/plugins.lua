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
  { "mattn/emmet-vim", ft = { "html", "xml" } },
  {
    "folke/which-key.nvim",
    cond = utils.vscode,
    opts = {},
    event = "VeryLazy",
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
        local file_name = vim.fn.expand "%:t"
        local configs = { vim.fn.stdpath "config", vim.env.USERPROFILE .. "\\.config\\wezterm" }
        local config_files = { ".wezterm.lua" }
        local is_in_config = vim.tbl_contains(configs, function(v)
          return string.find(path, "^" .. v) ~= nil
        end, { predicate = true })
        local is_config_file = vim.list_contains(config_files, file_name)

        return vim.fn.getbufvar(buf, "&modifiable") == 1 and not (is_in_config or is_config_file)
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
    event = "VeryLazy",
    opts = {},
  },
  {
    "b0o/SchemaStore",
    ft = { "json", "jsonc", "yaml" },
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
  {
    "aaronik/treewalker.nvim",
    opts = {},
    keys = {
      {
        "<leader>sl",
        "<cmd>Treewalker SwapRight<cr>",
        silent = true,
      },
      {
        "<leader>sh",
        "<cmd>Treewalker SwapLeft<cr>",
        silent = true,
      },
      {
        "<leader>sj",
        "<cmd>Treewalker SwapDown<cr>",
        silent = true,
      },
      {
        "<leader>sk",
        "<cmd>Treewalker SwapUp<cr>",
        silent = true,
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        mode = { "n", "x", "o" },
        desc = "Flash",
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        mode = { "n" },
        desc = "Flash Treesitter",
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        mode = { "o", "x" },
        desc = "Flash Remote",
      },
      {
        "R",
        function()
          require("flash").treesitter_search()
        end,
        mode = { "o", "x" },
        desc = "Flash Treesitter Search",
      }
    }
  }
}
