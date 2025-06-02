return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "text" },
  init = function()
    vim.g.table_mode_map_prefix = "<localleader>t"
  end
}
