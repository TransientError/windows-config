local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

return require("packer").startup(function(use)
  -- Have packer manage itself on windows or it always tries to clean itself
  use "wbthomason/packer.nvim"
  use {
    "sbdchd/neoformat",
    config = function()
      vim.keymap.set("", "<leader>cf", ":Neoformat<CR>")
    end,
  }
  use "tpope/vim-surround"
  use {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = "*.html,*.xml,*.plist,*.*proj"
    end,
    ft = { "html", "xml", "jsx" },
  }
  use "tpope/vim-commentary"
  use { "dag/vim-fish", ft = "fish" }
  use { "mattn/emmet-vim", ft = { "html", "xml" } }
  use { "cespare/vim-toml", ft = "toml" }
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
  require('kvwu-lsp').setup(use)
  require('kvwu-theme').setup(use, not_vscode)
  require('kvwu-debuggers').setup(use, not_vscode)
  require('kvwu-telescope').setup(use, not_vscode)
  require('kvwu-treesitter').setup(use, not_vscode)
  require('kvwu-navigation').setup(use, not_vscode)
  require('kvwu-python').setup(use, not_vscode)
  require('kvwu-misc-old-crap').setup(use, not_vscode)
  require('kvwu-version-control').setup(use, not_vscode)
end)
