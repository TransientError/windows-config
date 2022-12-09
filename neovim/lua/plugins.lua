local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

return require("packer").startup(function(use)
  -- Have packer manage itself on windows or it always tries to clean itself
  use "wbthomason/packer.nvim"
  use {
    "marko-cerovac/material.nvim",
    cond = not_vscode,
    config = require("kvwu-material").setup,
    after = "lualine.nvim",
    module = "material",
  }
  use {
    "nvim-lualine/lualine.nvim",
    config = require("kvwu-lualine").setup,
    cond = not_vscode,
  }
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
    cond = not_vscode,
  }
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
  use { "mattn/emmet-vim", ft = { "html", "jsx" } }
  use { "cespare/vim-toml", ft = "toml" }
  use "vim-scripts/ReplaceWithRegister"
  use { "jparise/vim-graphql", ft = "graphql" }
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
    cond = not_vscode,
    config = function()
      require("nvim-tree").setup {
        update_focused_file = {
          enable = true,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        view = {
          mappings = {
            custom_only = false,
            list = {
              { key = "l", action = "cd" },
            },
          },
        },
      }
      vim.keymap.set({ "n", "v" }, "<leader>op", ":NvimTreeToggle<CR>")
    end,
    cmd = { "NvimTreeToggle" },
    keys = "<leader>op",
    module = "nvim-tree",
    ft = ""
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
    cond = function()
      return vim.fn.exists "g:vscode" == 0 and vim.fn.glob ".git" ~= nil
    end,
    config = function()
      vim.keymap.set("n", "<leader>gg", ":Git<CR>")
    end,
  }
  use {
    "cedarbaum/fugitive-azure-devops.vim",
    cond = function()
      return require("kvwu-config").profiles.work
    end,
    requires = {
      "tpope/vim-rhubarb",
      "tpope/vim-fugitive",
    },
  }
  use {
    "nvim-telescope/telescope.nvim",
    cond = not_vscode,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local builtin = require "telescope.builtin"
      vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
      vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>,", builtin.buffers, {})
      vim.keymap.set("n", "<leader>ha", builtin.help_tags, {})
    end,
  }
  use {
    "nvim-telescope/telescope-project.nvim",
    config = function()
      local telescope = require "telescope"
      telescope.load_extension "project"
      vim.keymap.set("n", "<leader>pp", telescope.extensions.project.project)
    end,
    after = { "telescope.nvim" },
  }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", cond = not_vscode }
  use {
    "p00f/nvim-ts-rainbow",
    cond = not_vscode,
    config = function()
      local colors = require "material.colors"
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "python", "lua", "typescript" },
        highlight = {
          enable = true,
        },
        rainbow = {
          enable = true,
          colors = {
            colors.main.purple,
            colors.main.yellow,
            colors.main.blue,
            colors.main.cyan,
            colors.main.green,
            colors.main.orange,
            colors.main.red,
          },
        },
      }
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
  use {
    "petobens/poet-v",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    ft = "python",
    setup = function()
      vim.g.poetv_executables = { "poetry" }
    end,
  }
  use {
    "mfussenegger/nvim-dap",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("kvwu-nvim-dap").setup()
    end,
    requires = { "anuvyklack/hydra.nvim" },
    module = "dap",
  }
  use {
    "mxsdev/nvim-dap-vscode-js",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    ft = "typescript",
    requires = {
      "mfussenegger/nvim-dap",
      { "microsoft/vscode-js-debug", opt = true, run = "npm install --legacy-peer-deps && npm run compile" },
    },
    config = function()
      require("dap-vscode-js").setup {
        adapters = { "pwa-node" },
      }

      require("dap").configurations["typescript"] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          runtimeArgs = { "--nolazy", "-r", "ts-node/register", "--loader", "ts-node/esm.mjs" },
          cwd = "${fileDirname}",
          args = "${file}",
          sourceMaps = true,
        },
      }
    end,
  }
  use {
    "rcarriga/nvim-dap-ui",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    after = { "nvim-dap" },
    config = require("kvwu-dap-ui").setup,
  }
end)
