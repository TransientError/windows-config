return {
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "text" },
    init = function()
      vim.g.table_mode_map_prefix = "<localleader>t"
    end,
  },
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    keys = {
      { "<leader>Xt", "<cmd>edit D:/OneDrive - Microsoft/org-roam/todo.org<cr>", desc = "Open todo.org" },
      { "<localleader>A", "<cmd>lua require('orgmode').action('org_mappings.archive')<cr>", desc = "Archive subtree", ft = "org" },
      { "<localleader>t", "<cmd>lua require('orgmode').action('org_mappings.todo_next_state')<cr>", desc = "Set TODO state", ft = "org" },
      { "<localleader>ds", "<cmd>lua require('orgmode').action('org_mappings.org_schedule')<cr>", desc = "Schedule", ft = "org" },
      { "<localleader>dd", "<cmd>lua require('orgmode').action('org_mappings.org_deadline')<cr>", desc = "Deadline", ft = "org" },
    },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "D:/OneDrive - Microsoft/org-roam/**/*",
        org_default_notes_file = "D:/OneDrive - Microsoft/org-roam/todo.org",
        org_todo_keywords = { "TODO(t)", "PROJ(p)", "BLOCKED(b)", "HOLD(h)", "|", "DONE(d)", "CANCELLED(c)" },
        org_startup_folded = "showeverything",
        org_adapt_indentation = false,
        org_blank_before_new_entry = { heading = false, plain_list_item = false },
        mappings = {
          org = {
            org_meta_return = false,
          },
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function()
          local function on_heading_line()
            return vim.fn.getline("."):match("^%*+ ") ~= nil
          end

          local function at_end_of_heading()
            local line = vim.fn.getline(".")
            return line:match("^%*+%s*$") or (on_heading_line() and vim.trim(line:sub(vim.fn.col("."), vim.fn.col("$"))) == "")
          end

          vim.keymap.set("i", "<CR>", function()
            if at_end_of_heading() then
              local orgmode = require("orgmode")
              local item = orgmode.files:get_closest_headline()
              if item then
                local level = item:get_level()
                local end_line = item:get_range().end_line
                local new_heading = string.rep("*", level) .. " "
                vim.fn.append(end_line, new_heading)
                vim.api.nvim_win_set_cursor(0, { end_line + 1, #new_heading })
              end
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
            end
          end, { buffer = true })

          vim.keymap.set("i", "<Tab>", function()
            if at_end_of_heading() then
              local lnum = vim.fn.line(".")
              local line = vim.fn.getline(lnum)
              vim.fn.setline(lnum, "*" .. line)
              local stars = vim.fn.getline(lnum):match("^(%*+)")
              vim.api.nvim_win_set_cursor(0, { lnum, #stars + 1 })
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", false)
            end
          end, { buffer = true })

          vim.keymap.set("i", "<S-Tab>", function()
            if at_end_of_heading() then
              local lnum = vim.fn.line(".")
              local line = vim.fn.getline(lnum)
              if line:match("^%*%*") then
                vim.fn.setline(lnum, line:sub(2))
                local stars = vim.fn.getline(lnum):match("^(%*+)")
                vim.api.nvim_win_set_cursor(0, { lnum, #stars + 1 })
              end
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n", false)
            end
          end, { buffer = true })

          vim.keymap.set("n", "<Tab>", function()
            if on_heading_line() then
              require("orgmode").action("org_mappings.do_demote")
            end
          end, { buffer = true })

          vim.keymap.set("n", "<S-Tab>", function()
            if on_heading_line() then
              require("orgmode").action("org_mappings.do_promote")
            end
          end, { buffer = true })
        end,
      })
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
