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
-- but only update plugins whose latest git tag (or commit, for tagless repos)
-- is older than N days (default 14).
-- Supports headless: nvim --headless "+LazySyncSafe" +qa!
vim.api.nvim_create_user_command("LazySyncSafe", function(cmd_opts)
  local days = tonumber(cmd_opts.args) or 14
  local threshold = os.time() - (days * 86400)
  local headless = #vim.api.nvim_list_uis() == 0
  local lazy = require "lazy"

  -- Install missing + clean removed (same as sync)
  print("[LazySyncSafe] Installing missing plugins...")
  lazy.install { wait = headless, show = not headless }
  lazy.clean { wait = headless, show = not headless }

  -- Filter updates by tag age
  local plugins = lazy.plugins()
  local total = #plugins
  local eligible = {}
  local skipped = {}
  local commit_eligible = {}
  local commit_skipped = {}
  local commit_too_new = {}

  for idx, plugin in ipairs(plugins) do
    local dir = plugin.dir
    if dir and vim.fn.isdirectory(dir .. "/.git") == 1 then
      print(string.format("[LazySyncSafe] (%d/%d) Fetching %s...", idx, total, plugin.name))
      vim.fn.system { "git", "-C", dir, "fetch", "--tags", "--quiet", "origin" }

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
        -- Tagless plugin: find the newest remote commit older than the threshold
        local branch = plugin.branch
          or vim.fn.system({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "origin/HEAD" }):gsub("^origin/", ""):gsub("%s+$", "")
        if branch == "" then branch = "main" end

        local commit_out = vim.fn.systemlist {
          "git", "-C", dir, "log", "origin/" .. branch,
          "--format=%H %ct", "--first-parent",
        }
        local target_hash, target_ts
        if vim.v.shell_error == 0 then
          for _, line in ipairs(commit_out) do
            local hash, ts_str = line:match "^(%x+)%s+(%d+)$"
            if hash and ts_str then
              local ts = tonumber(ts_str)
              if ts <= threshold then
                target_hash, target_ts = hash, ts
                break
              end
            end
          end
        end

        if target_hash then
          local cur = vim.fn.system({ "git", "-C", dir, "rev-parse", "HEAD" }):gsub("%s+$", "")
          if cur ~= target_hash then
            table.insert(commit_eligible, {
              name = plugin.name, dir = dir, branch = branch,
              hash = target_hash, age = math.floor((os.time() - target_ts) / 86400),
            })
          else
            table.insert(commit_skipped,
              string.format("  %s (already at %s)", plugin.name, target_hash:sub(1, 7)))
          end
        else
          table.insert(commit_too_new,
            string.format("  %s (no commit older than %dd)", plugin.name, days))
        end
      end
    end
  end

  -- Checkout tagless plugins to their target commits and update the lockfile
  if #commit_eligible > 0 then
    local lockpath = vim.fn.stdpath "config" .. "/lazy-lock.json"
    local lockfile = vim.fn.filereadable(lockpath) == 1
      and vim.fn.json_decode(vim.fn.readfile(lockpath))
      or {}

    for _, info in ipairs(commit_eligible) do
      vim.fn.system { "git", "-C", info.dir, "checkout", info.hash }
      if lockfile[info.name] then
        lockfile[info.name].commit = info.hash
      end
    end

    local encoded = vim.fn.json_encode(lockfile)
    -- Pretty-print the lockfile (one entry per line, sorted)
    local ok, decoded = pcall(vim.fn.json_decode, encoded)
    if ok and type(decoded) == "table" then
      local keys = vim.tbl_keys(decoded)
      table.sort(keys)
      local lines = { "{" }
      for i, k in ipairs(keys) do
        local v = vim.fn.json_encode(decoded[k])
        local comma = i < #keys and "," or ""
        table.insert(lines, string.format("  %s: %s%s", vim.fn.json_encode(k), v, comma))
      end
      table.insert(lines, "}")
      vim.fn.writefile(lines, lockpath)
    else
      vim.fn.writefile({ encoded }, lockpath)
    end
  end

  local msg = {}
  if #skipped > 0 then
    table.insert(msg, "⏳ Skipped (tag < " .. days .. " days old):")
    for _, s in ipairs(skipped) do
      table.insert(msg, s)
    end
  end
  if #commit_too_new > 0 then
    table.insert(msg, "⏳ Tagless, no commit old enough:")
    for _, s in ipairs(commit_too_new) do
      table.insert(msg, s)
    end
  end
  if #commit_skipped > 0 then
    table.insert(msg, "✅ Tagless, already up to date:")
    for _, s in ipairs(commit_skipped) do
      table.insert(msg, s)
    end
  end
  if #commit_eligible > 0 then
    table.insert(msg, "📌 Tagless, checked out to oldest safe commit:")
    for _, info in ipairs(commit_eligible) do
      table.insert(msg, string.format("  %s → %s (%dd old)", info.name, info.hash:sub(1, 7), info.age))
    end
  end
  if #eligible > 0 then
    table.insert(msg, "✅ Updating " .. #eligible .. " tagged plugins...")
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO)
    lazy.update { plugins = eligible, wait = headless, show = not headless }
  else
    table.insert(msg, "✅ No tagged plugins eligible for update.")
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO)
  end
end, {
  nargs = "?",
  desc = "Sync plugins, but only update tags/commits older than N days (default: 14)",
})
