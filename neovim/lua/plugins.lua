return require("packer").startup(function(use)
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
    "folke/which-key.nvim",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("which-key").setup {}
    end,
  }
  use {
    "nvim-tree/nvim-tree.lua",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("nvim-tree").setup {
        update_focused_file = {
          enable = true,
        },
      }
      vim.keymap.set({ "n", "v" }, "<leader>op", ":NvimTreeToggle<CR>")
    end,
    cmd = { "NvimTreeToggle" },
    keys = "<leader>op",
  }
  use {
    "hrsh7th/nvim-cmp",
    opt = true,
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("kvwu-cmp").setup()
    end,
    requires = {
      { "hrsh7th/cmp-path", opt = true },
      { "hrsh7th/cmp-cmdline", opt = true },
      { "ray-x/cmp-treesitter", opt = true },
      { "hrsh7th/cmp-buffer", opt = true },
      { "hrsh7th/cmp-vsnip", opt = true },
      { "hrsh7th/vim-vsnip", opt = true },
      { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
      { "neovim/nvim-lspconfig", module = "lspconfig" },
    },
  }
  use {
    "tpope/vim-fugitive",
    config = function()
      return vim.fn.exists "g:vscode" == 0
    end,
  }
  use {
    "cedarbaum/fugitive-azure-devops.vim",
    cond = function ()
      return require("kvwu-config").profiles.work
    end,
    config = function ()
      vim.g.fugitive_azure_devops_ssh_user = "microsoft"
      vim.cmd "let g:fugitive_azure_devops_ssh_user = 'microsoft'"
    end,
    requires = {
      "tpope/vim-rhubarb",
      "tpope/vim-fugitive",
    }
  }
end)
