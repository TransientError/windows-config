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
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    opts = {},
    event = "LazyFile"
  },
  {
    "chentoast/marks.nvim",
    opts = {},
    event = "VeryLazy"
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
    cmd = "ToggleTerm"
  },
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_patterns = { ".git", "=nvim", "=work", "=utils" }
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
    event = "VeryLazy"
  },
}
