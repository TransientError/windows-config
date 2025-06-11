if require("utils").is_vscode() then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = { "Copilot" },
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = false,
          accept_word = "<C-right>",
          accept_line = "<C-S-right>",
        },
      },
    },
    keys = {
      {
        "<right>",
        function()
          local suggestion = require "copilot.suggestion"
          if suggestion.is_visible() then
            suggestion.accept()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<right>", true, false, true), "n", false)
          end
        end,
        mode = "i",
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatPrompts",
    },
    opts = {},
  },
}
