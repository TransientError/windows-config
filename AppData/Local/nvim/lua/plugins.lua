local utils = require "utils"

return {
  {
    "sbdchd/neoformat",
    init = function()
      vim.g.neoformat_enabled_cs = { "csharpier" }
      vim.g.neoformat_enabled_python = { "black" }
      vim.g.neoformat_enabled_ocaml = { "ocamlformat" }
    end,
    keys = {
      { "<leader>cf", ":Neoformat<CR>" },
    },
    cmd = "Neoformat",
  },
  { "tpope/vim-surround", event = "LazyFile" },
  { "tpope/vim-commentary", event = "LazyFile" },
  { "dag/vim-fish", ft = "fish" },
  { "mattn/emmet-vim", ft = { "html", "xml" } },
  { "vim-scripts/ReplaceWithRegister", event = "LazyFile" },
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
  { "Pocco81/auto-save.nvim", event = "VeryLazy" },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {
        "<leader>ot",
        ":ToggleTerm<CR>",
      },
    },
    opts = {
      -- this is buggy for me
      shade_terminals = false,
      hide_numbers = false,
    },
    cmd = "ToggleTerm",
  },
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_patterns = { ".git", "=nvim", "=work", "=utils", "*.sln", "*.csproj" }
    end,
  },
  {
    "alvan/vim-closetag",
    init = function()
      vim.g.closetag_filenames = "*.html,*.xml,*.*proj"
    end,
    ft = { "html", "xml" },
  },
  { "AndrewRadev/tagalong.vim", ft = { "html", "xml" } },
  {
    "williamboman/mason.nvim", opts = {}
  },
  {
    "b0o/SchemaStore",
    ft = { "json", "jsonc", "yaml" },
  },
  {
    "vim-bicep",
    ft = "bicep",
  },
  {
    "folke/trouble.nvim",
    opts = {},
    event = "VeryLazy",
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
