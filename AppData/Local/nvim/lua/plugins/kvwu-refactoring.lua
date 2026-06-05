if require("utils").is_vscode() then
  return {}
end

return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = { "lewis6991/async.nvim" },
  opts = { show_success_message = true },
  ft = { "c", "cpp", "lua", "python", "javascript", "typescript", "go", "csharp" },
  cmd = "Refactor",
  keys = {
    { "<leader>r", "", desc = "+refactor", mode = { "n", "v" } },
    {
      "<leader>rs",
      function()
        return require("refactoring").select_refactor()
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Select Refactor",
    },
    {
      "<leader>ri",
      function()
        return require("refactoring").inline_var()
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Inline Variable",
    },
    {
      "<leader>rI",
      function()
        return require("refactoring").inline_func()
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Inline Function",
    },
    {
      "<leader>rf",
      function()
        return require("refactoring").extract_func()
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Extract Function",
    },
    {
      "<leader>rx",
      function()
        return require("refactoring").extract_var()
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Extract Variable",
    },
    {
      "<leader>rp",
      function()
        return require("refactoring.debug").print_var { output_location = "below" }
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Debug Print Variable",
    },
    {
      "<leader>rP",
      function()
        return require("refactoring.debug").print_loc { output_location = "below" }
      end,
      expr = true,
      desc = "Debug Print Location",
    },
    {
      "<leader>rc",
      function()
        return require("refactoring.debug").cleanup { restore_view = true }
      end,
      expr = true,
      desc = "Debug Print Cleanup",
    },
  },
}
