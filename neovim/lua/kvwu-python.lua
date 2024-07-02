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
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowGreen",
        "RainbowBlue",
        "RainbowCyan",
        "RainbowViolet",
      }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function ()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      end)

      require("ibl").setup { indent = { highlight = highlight } }
    end,
    ft = { "python", "yaml" },
    cond = not_vscode,
  }
  use "michaeljsmith/vim-indent-object"
end

return kvwu_python
