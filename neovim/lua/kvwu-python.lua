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
      vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

      require("indent_blankline").setup {
        show_char_blankline = " ",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
          "IndentBlanklineIndent3",
          "IndentBlanklineIndent4",
          "IndentBlanklineIndent5",
          "IndentBlanklineIndent6",
        },
      }
    end,
    ft = { "python", "yaml" },
    cond = not_vscode,
  }
  use "michaeljsmith/vim-indent-object"
end

return kvwu_python
