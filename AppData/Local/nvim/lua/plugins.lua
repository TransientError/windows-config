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
  { "Pocco81/auto-save.nvim", event = "VeryLazy" },
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
      {"<right>", 'copilot#Accept("\\<right>")', mode = "i", expr = true, replace_keycodes = false }
    }
  },
}
