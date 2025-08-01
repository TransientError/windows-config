local map = vim.keymap
local vscode = require "vscode"

vim.opt.clipboard = "unnamed"

map.set("n", "M", function()
  vscode.call "bookmarks.toggle"
end)
map.set("n", "~", function()
  vscode.call "bookmarks.list"
end)

vim.keymap.set({ "n", "x" }, "<Space>", function()
  vim.fn.VSCodeNotify "vspacecode.space"
end, { noremap = true, silent = true })
