local surround_prefix = "gj"
local add = surround_prefix .. "a"
local delete = surround_prefix .. "d"
local replace = surround_prefix .. "r"

return {
  {
    "echasnovski/mini.surround",
    version = "*",
    -- lazy = false,
    ---@type LazyKeysSpec[]
    keys = {
      { add, desc = "add surround", mode = { "n", "x", "o" } },
      { delete, desc = "delete surround", mode = { "n", "x", "o" } },
      { replace, desc = "replace surround", mode = { "n", "x", "o" } },
      {
        "S",
        ":<C-u>lua require('mini.surround').add 'visual'<cr>",
        mode = "x",
      },
    },
    opts = {
      mappings = {
        add = add,
        delete = delete,
        replace = replace,
      },
    },
  },
  {
    "wellle/targets.vim",
    event = "LazyFile",
    init = function()
      vim.cmd [[
        autocmd User targets#mappings#user call targets#mappings#extend({
           \ 'a': {'argument': [{'o':'[({<[]', 'c':'[]}>)]', 's': ','}]}
           \ })
     ]]
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require "nvim-autopairs"
      npairs.setup {
        check_ts = true,
      }
      local Rule = require "nvim-autopairs.rule"
      npairs.add_rule(Rule("`", "`", "-ocaml"))
    end,
  },
  {
    "echasnovski/mini.splitjoin",
    version = "*",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "gS",
        mode = { "n" },
        desc = "Mini SplitJoin toggle",
      },
    },
  },
  {
    "echasnovski/mini.operators",
    version = "*",
    event = "VeryLazy",
    opts = {
      sort = {
        prefix = "",
      },
      multiply = {
        prefix = "",
      },
    },
    keys = {
      {
        "g=",
        mode = { "n", "x", "o" },
        desc = "Mini Operators: Evaluate",
      },
      {
        "gx",
        mode = { "n", "x", "o" },
        desc = "Mini Operators: Exchange",
      },
      {
        "gr",
        mode = { "n", "x", "o" },
        desc = "Mini Operators: replace",
      },
    },
  },
  {
    "ggandor/leap.nvim",
    lazy = false,
    init = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap: Search" })
      vim.keymap.set({ "n", "o" }, "S", "<Plug>(leap-from-window)", { desc = "Leap: from window" })
      vim.keymap.set({ "n", "x", "o" }, "gs", function()
        require("leap.remote").action()
      end)
      vim.keymap.set({ "n", "x", "o" }, "R", function()
        require("leap.treesitter").select()
      end)
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = true,
        },
      },
    },
  },
}
