-- init.lua — bootstrap only, all logic lives in lua/config/* and lua/plugins/*

-- 1. Leader keys (must be set before plugins load)
require("config.globals")

-- 2. Core Neovim options
require("config.options")

-- 3. Keymaps
require("config.keymaps")

-- 4. Autocommands
require("config.autocmds")

-- 5. Plugin manager + all plugins under lua/plugins/
require("config.lazy")

------------------------------------------------------------------------
-- Saved Directory Search System
-- Commands: :SearchDirAdd  :SearchDirRemove  :SearchDirList
-- Keymaps (defined in keymaps.lua):
--   <leader>sf  → find files in cwd
--   <leader>s]  → find files in a saved directory
--   <leader>sG  → live grep in cwd
--   <leader>sa  → SearchDirAdd
--   <leader>sR  → SearchDirRemove
--   <leader>sl  → SearchDirList
------------------------------------------------------------------------
local quick_search_data_path = vim.fn.stdpath("data") .. "/quick_search_dirs.json"

local function quick_search_read_dirs()
	local file = io.open(quick_search_data_path, "r")
	if not file then
		return {}
	end
	local content = file:read("*a")
	file:close()
	if content == "" then
		return {}
	end
	local ok, data = pcall(vim.fn.json_decode, content)
	if ok and type(data) == "table" then
		return data
	end
	return {}
end

local function quick_search_write_dirs(dirs)
	local file = io.open(quick_search_data_path, "w")
	if file then
		file:write(vim.fn.json_encode(dirs))
		file:close()
	end
end

local function select_saved_dir_and_find_files()
	local dirs = quick_search_read_dirs()
	if #dirs == 0 then
		vim.notify("No directories saved. Use :SearchDirAdd to add some.", vim.log.levels.WARN)
		return
	end
	vim.ui.select(dirs, {
		prompt = "Select directory to search files in:",
		format_item = function(item)
			return item.name .. " (" .. item.path .. ")"
		end,
	}, function(choice)
		if not choice then
			return
		end
		local expanded_path = vim.fn.expand(choice.path)
		if vim.fn.isdirectory(expanded_path) == 1 then
			require("telescope.builtin").find_files({ cwd = expanded_path })
		else
			vim.notify("Directory not found: " .. choice.path, vim.log.levels.WARN)
		end
	end)
end

vim.api.nvim_create_user_command("SearchDirAdd", function()
	vim.ui.input({ prompt = "Directory Path: ", default = vim.fn.getcwd() }, function(path)
		if not path or path == "" then
			return
		end
		vim.ui.input({ prompt = "Short Name: " }, function(name)
			if not name or name == "" then
				return
			end
			local dirs = quick_search_read_dirs()
			table.insert(dirs, { name = name, path = path })
			quick_search_write_dirs(dirs)
			print("Added '" .. name .. "' to saved search directories.")
		end)
	end)
end, { desc = "Add a directory to saved search list" })

vim.api.nvim_create_user_command("SearchAddDir", function()
	vim.cmd("SearchDirAdd")
end, { desc = "Alias for SearchDirAdd" })

vim.api.nvim_create_user_command("SearchDirRemove", function()
	local dirs = quick_search_read_dirs()
	if #dirs == 0 then
		print("No directories saved to remove.")
		return
	end
	vim.ui.select(dirs, {
		prompt = "Select directory to REMOVE:",
		format_item = function(item)
			return item.name .. " (" .. item.path .. ")"
		end,
	}, function(choice, idx)
		if choice then
			table.remove(dirs, idx)
			quick_search_write_dirs(dirs)
			print("Removed '" .. choice.name .. "'.")
		end
	end)
end, { desc = "Remove a directory from saved search list" })

vim.api.nvim_create_user_command("SearchDirList", function()
	local dirs = quick_search_read_dirs()
	if #dirs == 0 then
		print("No directories saved. Use :SearchDirAdd to add some.")
		return
	end
	print("Saved search directories:")
	for i, dir in ipairs(dirs) do
		print(string.format("  %d. %s → %s", i, dir.name, dir.path))
	end
end, { desc = "List all saved search directories" })

-- Keymap for saved-directory file picker
vim.keymap.set("n", "<leader>s]", select_saved_dir_and_find_files, { desc = "[S]earch files in saved directory" })
