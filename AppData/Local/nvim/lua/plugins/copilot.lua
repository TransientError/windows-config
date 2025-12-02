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
    keys = {
      {"<leader>oc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat"},
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
    opts = {
      model = "claude-sonnet-4",
      prompts = {
        generate = {
          prompt = "Generate template for this file",
          system = "Generate the boilerplate for this file. You may find additional information in the comments in the file",
        },
        imports = {
          prompt = "Generate imports for this file",
          system = "Fix the imports in this file",
        }
      },
      sticky = {
        "#buffer"
      }
    },
  },
}
