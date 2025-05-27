local utils = require "utils"
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    cond = utils.not_vscode,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local ft = vim.bo.filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if lang == nil then
            return
          end

          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })

      vim.treesitter.language.register("powershell", "ps1")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false,
    branch = "main",
    opts = {
      move = {
        set_jumps = true,
      },
      select = {
        include_surrounding_whitespace = {
          ["@parameter.outer"] = true,
        }
      }
    },
    keys = function()
      local move = require "nvim-treesitter-textobjects.move"
      local swap = require "nvim-treesitter-textobjects.swap"
      ---@type LazyKeysSpec[]
      local move_mappings = {
        {
          "]f",
          function()
            move.goto_next_start("@function.outer", "textobjects")
          end,
        },
        {
          "]c",
          function()
            move.goto_next_start("@class.outer", "textobjects")
          end,
        },
        {
          "[f",
          function()
            move.goto_previous_start("@function.outer", "textobjects")
          end,
        },
        {
          "[c",
          function()
            move.goto_previous_start("@class.outer", "textobjects")
          end,
        },
      }

      local swap_mappings = {
        {
          "<leader>a",
          function()
            swap.swap_next("@parameter.inner", "textobjects")
          end,
        },
        {
          "<leader>A",
          function()
            swap.swap_previous("@parameter.outer", "textobjects")
          end,
        },
      }

      local select = require "nvim-treesitter-textobjects.select"
      local select_mappings = {
        {
          "af",
          function()
            select.select_textobject("@function.outer", "textobjects")
          end,
        },
        {
          "ac",
          function()
            select.select_textobject("@class.outer", "textobjects")
          end,
        },
        {
          "if",
          function()
            select.select_textobject("@function.inner", "textobjects")
          end,
        },
        {
          "ic",
          function()
            select.select_textobject("@class.inner", "textobjects")
          end,
        },
      }

      for _, mapping in ipairs(move_mappings) do
        mapping.mode = { "n", "x", "o" }
      end

      for _, mapping in ipairs(swap_mappings) do
        mapping.mode = { "n" }
      end

      for _, mapping in ipairs(select_mappings) do
        mapping.mode = { "x", "o" }
      end

      return utils.concat(move_mappings, swap_mappings, select_mappings)
    end,
  },
}
