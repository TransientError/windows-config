-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "

local Event = require "lazy.core.handler.event"
Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

-- Setup lazy.nvim
require("lazy").setup {
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "material" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false },
  change_detection = {
    enabled = false,
    notify = false,
  }
}

-- :LazySyncSafe [days] — supply chain safety: install + clean + update,
-- but only update plugins whose latest git tag is older than N days (default 14).
-- Supports headless: nvim --headless "+LazySyncSafe" +qa!
vim.api.nvim_create_user_command("LazySyncSafe", function(cmd_opts)
  local days = tonumber(cmd_opts.args) or 14
  local threshold = os.time() - (days * 86400)
  local headless = #vim.api.nvim_list_uis() == 0
  local lazy = require "lazy"

  -- Install missing + clean removed (same as sync)
  lazy.install { wait = headless, show = not headless }
  lazy.clean { wait = headless, show = not headless }

  -- Filter updates by tag age
  local plugins = lazy.plugins()
  local eligible = {}
  local skipped = {}
  local no_tags = {}

  for _, plugin in ipairs(plugins) do
    local dir = plugin.dir
    if dir and vim.fn.isdirectory(dir .. "/.git") == 1 then
      vim.fn.system { "git", "-C", dir, "fetch", "--tags", "--quiet" }

      local out = vim.fn.systemlist {
        "git", "-C", dir,
        "for-each-ref", "--sort=-creatordate",
        "--format=%(creatordate:unix) %(refname:short)",
        "--count=1", "refs/tags",
      }
      local tag_ts, tag_name
      if vim.v.shell_error == 0 and #out > 0 and out[1] ~= "" then
        local ts, name = out[1]:match "^(%d+)%s+(.+)$"
        if ts then
          tag_ts, tag_name = tonumber(ts), name
        end
      end

      if tag_ts then
        if tag_ts <= threshold then
          table.insert(eligible, plugin.name)
        else
          local age = math.floor((os.time() - tag_ts) / 86400)
          table.insert(skipped, string.format("  %s (%s, %dd old)", plugin.name, tag_name, age))
        end
      else
        table.insert(no_tags, plugin.name)
      end
    end
  end

  local msg = {}
  if #skipped > 0 then
    table.insert(msg, "⏳ Skipped (tag < " .. days .. " days old):")
    for _, s in ipairs(skipped) do
      table.insert(msg, s)
    end
  end
  if #no_tags > 0 then
    table.insert(msg, "⚠️  No tags (skipped): " .. table.concat(no_tags, ", "))
  end
  if #eligible > 0 then
    table.insert(msg, "✅ Updating " .. #eligible .. " plugins...")
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO)
    lazy.update { plugins = eligible, wait = headless, show = not headless }
  else
    table.insert(msg, "✅ No plugins eligible for update.")
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO)
  end
end, {
  nargs = "?",
  desc = "Sync plugins, but only update tags older than N days (default: 14)",
})
