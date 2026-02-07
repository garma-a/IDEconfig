--Load global settings first (leader keys, etc.)
require("config.globals")

-- Load basic vim options
require("config.options")

-- Load keymaps
require("config.keymaps")
-- Load autocommands
require("config.autocmds")

-- Bootstrap and setup lazy.nvim plugin manager
require("config.lazy")

-- Helper function to determine current working directory (same logic as ToggleBottomTerminal)
local term = require("harpoon.term")

local function get_current_working_directory()
	local bufn = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(bufn)
	local cwd = ""
	if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
		cwd = vim.fn.fnamemodify(bufname, ":p:h")
	else
		cwd = vim.fn.getcwd()
	end
	return cwd
end

-- Track terminals and previous file buffer
local harpoon_term_bufs = {} -- term_num -> bufid
local harpoon_prev_bufs = {} -- term_num -> file-bufid
local harpoon_term_initialized = {} -- term_num -> boolean (whether we've sent cd + cls already)
local last_file_buf = nil

local function is_harpoon_terminal_buf(buf)
	for _, tbuf in pairs(harpoon_term_bufs) do
		if tbuf == buf then
			return true
		end
	end
	return false
end

local function toggle_harpoon_terminal(term_num)
	local cur_buf = vim.api.nvim_get_current_buf()

	-- If we are already in this terminal -> go back to its previous file buffer
	if harpoon_term_bufs[term_num] and cur_buf == harpoon_term_bufs[term_num] then
		local prev = harpoon_prev_bufs[term_num] or last_file_buf
		if prev and vim.api.nvim_buf_is_loaded(prev) then
			vim.api.nvim_set_current_buf(prev)
		else
			vim.cmd("b#")
		end
		return
	end

	-- We are not in this terminal -> go to it

	-- If we're currently in a *file* buffer, update last_file_buf and this term's prev
	if not is_harpoon_terminal_buf(cur_buf) then
		last_file_buf = cur_buf
		harpoon_prev_bufs[term_num] = cur_buf
	else
		-- We are in some other terminal:
		-- if this term has no prev yet, fall back to last_file_buf (the last real file)
		if not harpoon_prev_bufs[term_num] then
			harpoon_prev_bufs[term_num] = last_file_buf
		end
	end

	-- Jump to the terminal
	term.gotoTerminal(term_num)

	-- Record this terminal's buffer
	harpoon_term_bufs[term_num] = vim.api.nvim_get_current_buf()

	-- Set working directory inside terminal (optional)
	if not harpoon_term_initialized[term_num] then
		local cwd = get_current_working_directory()
		if cwd ~= "" and vim.fn.isdirectory(cwd) == 1 then
			local escaped_cwd = vim.fn.fnameescape(cwd)
			-- Send cd + cls only once
			term.sendCommand(term_num, "cd " .. escaped_cwd .. " && cls\n")
		end
		harpoon_term_initialized[term_num] = true
	end
	-- After first init, we don't send any command -> terminal output is preserved
end

-- Keymaps
vim.keymap.set("n", "<A-1>", function()
	toggle_harpoon_terminal(1)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-2>", function()
	toggle_harpoon_terminal(2)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-3>", function()
	toggle_harpoon_terminal(3)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-4>", function()
	toggle_harpoon_terminal(4)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-5>", function()
	toggle_harpoon_terminal(5)
end, { noremap = true, silent = true })

vim.keymap.set("n", ">", function()
	require("harpoon.ui").nav_next()
end, { desc = "Harpoon Next" })

vim.keymap.set("n", "<", function()
	require("harpoon.ui").nav_prev()
end, { desc = "Harpoon Previous" })

vim.keymap.set("n", "<C-]>", function()
	require("harpoon.ui").nav_file(1)
end, { desc = "Go to Harpoon window 1" })

vim.keymap.set("n", "<C-[>", function()
	require("harpoon.ui").nav_file(2)
end, { desc = "Go to Harpoon window 2" })

vim.keymap.set("n", "<C-p>", function()
	require("harpoon.ui").nav_file(3)
end, { desc = "Go to Harpoon window 3" })

vim.keymap.set("n", "<C-o>", function()
	require("harpoon.ui").nav_file(4)
end, { desc = "Go to Harpoon window 4" })

------------------------------------------------------------------------
------------------------------------------------------------------------
---
---
-- Opencode Terminal Toggle (Global Command)
-- Place this in your init.lua
--
-- local opencode_state = {
-- 	buf = nil, -- opencode terminal buffer
-- 	prev_buf = nil, -- last file buffer before entering opencode
-- 	initialized = false, -- whether terminal was created
-- }
--
-- -- Helper to check if buffer is a real file buffer
-- local function is_file_buffer(buf)
-- 	if not vim.api.nvim_buf_is_loaded(buf) then
-- 		return false
-- 	end
-- 	local buftype = vim.bo[buf].buftype
-- 	return buftype == "" or buftype == "acwrite"
-- end
--
-- -- Helper to check if we're in the opencode terminal
-- local function is_in_opencode_terminal()
-- 	local cur_buf = vim.api.nvim_get_current_buf()
-- 	return opencode_state.buf and cur_buf == opencode_state.buf
-- end
--
-- -- Main toggle function
-- local function toggle_opencode_terminal()
-- 	local cur_buf = vim.api.nvim_get_current_buf()
--
-- 	-- Case 1: We're already in opencode terminal -> go back to previous buffer
-- 	if is_in_opencode_terminal() then
-- 		local prev = opencode_state.prev_buf
--
-- 		-- Try to go to previous buffer with error handling
-- 		if prev and vim.api.nvim_buf_is_valid(prev) and vim.api.nvim_buf_is_loaded(prev) then
-- 			local success = pcall(vim.api.nvim_set_current_buf, prev)
-- 			if not success then
-- 				-- If switching failed, try alternate buffer
-- 				local alt_success = pcall(vim.cmd, "b#")
-- 				if not alt_success then
-- 					-- If that also failed, just do nothing (stay in opencode)
-- 					return
-- 				end
-- 			end
-- 		else
-- 			-- Try alternate buffer with error handling
-- 			local success = pcall(vim.cmd, "b#")
-- 			if not success then
-- 				-- If no alternate buffer, just stay in opencode
-- 				return
-- 			end
-- 		end
-- 		return
-- 	end
--
-- 	-- Case 2: Save current buffer as previous (only if it's valid)
-- 	if vim.api.nvim_buf_is_valid(cur_buf) then
-- 		opencode_state.prev_buf = cur_buf
-- 	end
--
-- 	-- Case 3: If terminal exists and is valid, switch to it
-- 	if
-- 		opencode_state.buf
-- 		and vim.api.nvim_buf_is_valid(opencode_state.buf)
-- 		and vim.api.nvim_buf_is_loaded(opencode_state.buf)
-- 	then
-- 		vim.api.nvim_set_current_buf(opencode_state.buf)
--
-- 		-- Enter insert mode
-- 		vim.schedule(function()
-- 			vim.cmd("startinsert")
-- 		end)
-- 		return
-- 	end
--
-- 	-- Case 4: Create new terminal for the first time
-- 	-- Create a new buffer
-- 	local buf = vim.api.nvim_create_buf(false, true)
-- 	vim.api.nvim_set_current_buf(buf)
--
-- 	-- Open terminal and run opencode
-- 	vim.fn.termopen("opencode --port 12000", {
-- 		on_exit = function()
-- 			-- Clean up when terminal exits
-- 			opencode_state.buf = nil
-- 			opencode_state.initialized = false
-- 		end,
-- 	})
--
-- 	-- Store the buffer
-- 	opencode_state.buf = buf
-- 	opencode_state.initialized = true
--
-- 	-- Set buffer options
-- 	vim.bo[buf].buflisted = false
-- 	vim.bo[buf].bufhidden = "hide"
--
-- 	-- Enter insert mode immediately
-- 	vim.schedule(function()
-- 		vim.cmd("startinsert")
-- 	end)
-- end
--
-- -- Keymap for Alt+v (works from both normal and terminal mode)
-- vim.keymap.set({ "n", "t" }, "<A-v>", function()
-- 	local mode = vim.fn.mode()
--
-- 	-- If in terminal mode, exit it first
-- 	if mode == "t" then
-- 		vim.cmd("stopinsert")
-- 		vim.schedule(toggle_opencode_terminal)
-- 	else
-- 		toggle_opencode_terminal()
-- 	end
-- end, { desc = "Toggle opencode terminal", noremap = true, silent = true })
