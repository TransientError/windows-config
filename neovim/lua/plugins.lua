local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

return require("packer").startup(function(use)
  -- Have packer manage itself on windows or it always tries to clean itself
  use "wbthomason/packer.nvim"
  use {
    "sbdchd/neoformat",
    config = function()
      vim.keymap.set("", "<leader>cf", ":Neoformat<CR>", { noremap = true })
      vim.g.neoformat_enabled_cs = { "csharpier" }
      vim.g.neoformat_enabled_python = { "black" }
      vim.g.neoformat_enabled_ocaml = { "ocamlformat" }
    end,
  }
  use "tpope/vim-surround"
  use "tpope/vim-commentary"
  use { "dag/vim-fish", ft = "fish" }
  use { "mattn/emmet-vim", ft = { "html", "xml" } }
  use "vim-scripts/ReplaceWithRegister"
  use {
    "wellle/targets.vim",
    config = function()
      vim.cmd [[
         autocmd User targets#mappings#user call targets#mappings#extend({
            \ 'a': {'argument': [{'o':'[({<[]', 'c':'[]}>)]', 's': ','}]}
            \ })
      ]]
    end,
  }
  use "ggandor/lightspeed.nvim"
  use {
    "folke/which-key.nvim",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("which-key").setup {}
    end,
  }
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  }
  use {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup {}
    end,
  }
  use "Pocco81/auto-save.nvim"
  require('kvwu-lsp').setup(use)
  require('kvwu-theme').setup(use, not_vscode)
  require('kvwu-debuggers').setup(use, not_vscode)
  require('kvwu-telescope').setup(use, not_vscode)
  require('kvwu-treesitter').setup(use, not_vscode)
  require('kvwu-navigation').setup(use, not_vscode)
  require('kvwu-python').setup(use, not_vscode)
  require('kvwu-misc-old-crap').setup(use, not_vscode)
  require('kvwu-version-control').setup(use, not_vscode)
  use {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup {
        -- this is buggy for me
        shade_terminals = false,
        hide_numbers = false,
      }
      vim.keymap.set("", "<leader>ot", ":ToggleTerm<CR>")
    end,
  }
  use {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = { ".git", "=nvim" }
    end,
  }
end)
