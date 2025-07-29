return {
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "text" },
    init = function()
      vim.g.table_mode_map_prefix = "<localleader>t"
    end,
  },
  {
    "echaya/neowiki.nvim",
    opts = {
      wiki_dirs = {
        { name = "notes", path = "~/OneDrive/Documents/neowiki" },
      },
    },
    keys = function ()
      local neowiki = require("neowiki")
      return {
        { "<leader>ww", neowiki.open_wiki, desc = "open wiki" },
        { "<leader>wW", neowiki.open_wiki_floating, desc = "open floating" },
        { "<leader>wt", neowiki.open_wiki_new_tab, desc = "wiki new tab" },
      }
    end
  },
}
