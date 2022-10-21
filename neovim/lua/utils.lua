local g = vim.g
local opt = vim.opt
local fn = vim.fn
local cmd = vim.cmd

local utils = {}

function utils.process_settings(settings_table)
	for k, v in pairs(settings_table.opt) do
		opt[k] = v
	end
end

return utils
