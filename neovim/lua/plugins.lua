return require("packer").startup(function()
  use {
    "kaicataldo/material.vim",
    config = function()
      vim.g.material_theme_style = "dark"
      vim.cmd "colorscheme material"
      vim.opt.background = "dark"
      if vim.fn.has "termguicolors" == 1 then
        vim.opt.termguicolors = true
      end
    end,
  }
  use {
    "sbdchd/neoformat",
    config = function()
      vim.keymap.set("", "<leader>cf", ":Neoformat<CR>")
    end,
  }
  use "tpope/vim-surround"
  use {
    "itchyny/lightline.vim",
    config = function()
      vim.g.lightline = { colorscheme = "material_vim" }
    end,
  }
  use "lambdalisue/suda.vim"
  use "airblade/vim-gitgutter"
  use {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = "*.html,*.xml,*.plist,*.*proj"
    end,
  }
  use "tpope/vim-commentary"
  use { "dag/vim-fish", ft = "fish" }
  use "junegunn/fzf.vim"
  use "mattn/emmet-vim"
  use { "cespare/vim-toml", ft = "toml" }
  use "vim-scripts/ReplaceWithRegister"
  use { "jparise/vim-graphql", ft = "graphql" }
  use "wellle/targets.vim"
  use "ggandor/lightspeed.nvim"
  use "michaeljsmith/vim-indent-object"
  use {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
    end,
    cmd = {'NvimTreeToggle', 'NvimTreeOpen'}
  }
end)
