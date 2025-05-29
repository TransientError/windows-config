if require("utils").is_vscode() then
  return {}
end

return {
  "akinsho/toggleterm.nvim",
  keys = {
    {
      "<leader>ot",
      ":ToggleTerm<CR>",
    },
  },
  opts = {
    -- this is buggy for me
    shade_terminals = false,
    hide_numbers = false,
  },
  cmd = "ToggleTerm",
}
