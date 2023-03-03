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
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.keymap.set("n", "<leader>mp", ":PoetvActivate | LspRestart<CR>")
        end,
      })
    end,
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
      }
    end,
    ft = {"python", "yaml"},
    cond = not_vscode,
  }
  use "michaeljsmith/vim-indent-object"
end

return kvwu_python
