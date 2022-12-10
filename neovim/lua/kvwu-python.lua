local kvwu_python = {}

function kvwu_python.setup(use, not_vscode)
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
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
      }
    end,
    ft = "python",
    cond = not_vscode,
  }
  use "michaeljsmith/vim-indent-object"
end

return kvwu_python
