if require("utils").is_vscode() then
  return {}
end

return {
  "ThePrimeagen/refactoring.nvim",
  opts = { show_success_message = true },
  ft = { "c", "cpp", "lua", "python", "javascript", "typescript", "go", "csharp" },
  cmd = "Refactor",
  keys = function()
    local refactoring = require "refactoring"
    return {
      { "<leader>r", "", desc = "+refactor", mode = { "n", "v" } },
      {
        "<leader>rs",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Refactor",
      },
      {
        "<leader>ri",
        function()
          refactoring.refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Inline Variable",
      },
      {
        "<leader>rf",
        function()
          refactoring.refactor "Extract Function"
        end,
        mode = "v",
        desc = "Extract Function",
      },
      {
        "<leader>rx",
        function()
          ("refactoring").refactor "Extract Variable"
        end,
        mode = "v",
        desc = "Extract Variable",
      },
      {
        "<leader>rp",
        function()
          refactoring.debug.printf { below = false }
        end,
      },
      {
        "<leader>rv",
        function()
          refactoring.debug.print_var {}
        end,
        mode = { "n", "x" },
      },
      {
        "<leader>rc",
        function()
          refactoring.debug.cleanup {}
        end,
      },
      { "<localleader>r", "", desc = "+refactor", mode = { "n", "v" } },
      {
        "<localleader>rs",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Refactor",
      },
      {
        "<localleader>ri",
        function()
          refactoring.refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Inline Variable",
      },
      {
        "<localleader>rf",
        function()
          refactoring.refactor "Extract Function"
        end,
        mode = "v",
        desc = "Extract Function",
      },
      {
        "<localleader>rx",
        function()
          ("refactoring").refactor "Extract Variable"
        end,
        mode = "v",
        desc = "Extract Variable",
      },
      {
        "<localleader>rp",
        function()
          refactoring.debug.printf { below = false }
        end,
      },
      {
        "<localleader>rv",
        function()
          refactoring.debug.print_var {}
        end,
        mode = { "n", "x" },
      },
      {
        "<localleader>rc",
        function()
          refactoring.debug.cleanup {}
        end,
      },
    }
  end,
  config = function(_, opts)
    require("refactoring").setup(opts)
    require("telescope").load_extension "refactoring"
  end,
}
