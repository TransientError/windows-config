return {
  {
    "sbdchd/neoformat",
    config = function()
      vim.keymap.set("", "<leader>cf", ":Neoformat<CR>", { noremap = true })
      vim.g.neoformat_enabled_cs = { "csharpier" }
      vim.g.neoformat_enabled_python = { "black" }
      vim.g.neoformat_enabled_ocaml = { "ocamlformat" }
    end,
  },
  "tpope/vim-surround",
  "tpope/vim-commentary",
  { "dag/vim-fish", ft = "fish" },
  { "mattn/emmet-vim", ft = { "html", "xml" } },
  "vim-scripts/ReplaceWithRegister",
  {
   "wellle/targets.vim",
   config = function()
     vim.cmd [[
        autocmd User targets#mappings#user call targets#mappings#extend({
           \ 'a': {'argument': [{'o':'[({<[]', 'c':'[]}>)]', 's': ','}]}
           \ })
     ]]
   end,
  },
  "ggandor/lightspeed.nvim",
  {
    "folke/which-key.nvim",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("which-key").setup {}
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup {}
    end,
  },
  "Pocco81/auto-save.nvim",
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup {
        -- this is buggy for me
        shade_terminals = false,
        hide_numbers = false,
      }
      vim.keymap.set("", "<leader>ot", ":ToggleTerm<CR>")
    end,
  },
  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = { ".git", "=nvim" }
    end,
  },
  {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = "*.html,*.xml,*.*proj"
    end,
  },
  "AndrewRadev/tagalong.vim",
}
