vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
local map = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<A-c>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "<A-c>", "<Esc>", opts)
vim.keymap.set("v", "<A-c>", "<Esc>", opts)
vim.keymap.set("t", "<A-c>", "<C-\\><C-n>", opts)

-- Recording macros and behavior changes
vim.keymap.set("n", "m", "q", opts)
vim.keymap.set("n", "M", "q", opts)
vim.keymap.set("n", "Q", "I", opts)
vim.keymap.set("n", "q", "i", opts)
vim.keymap.set("n", "<leader>e", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

-- Indentation and moving down
vim.keymap.set("n", "+", "=", opts)
vim.keymap.set("n", "=", "+", opts)
vim.keymap.set("v", "+", "=", opts)
vim.keymap.set("v", "=", "+", opts)

vim.keymap.set("n", "w", "b", opts)
vim.keymap.set("v", "w", "b", opts)
vim.keymap.set("n", "W", "B", opts)
vim.keymap.set("v", "W", "B", opts)

vim.keymap.set("n", "E", "W", opts)
vim.keymap.set("v", "E", "W", opts)

vim.keymap.set("n", "e", "w", opts)
vim.keymap.set("v", "e", "w", opts)

vim.keymap.set("n", "}", "<C-d>", opts)

vim.keymap.set("n", "{", "<C-u>", opts)

vim.keymap.set("n", "<C-d>", "}", { noremap = true, silent = true })

vim.keymap.set("n", "<C-e>", "{", { noremap = true, silent = true })

vim.keymap.set("n", "<C-x>", "<Plug>(matchup-%)", {})
vim.keymap.set("v", "<C-x>", "<Plug>(matchup-%)", {})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<A-left>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<A-right>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<A-down>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<A-up>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("i", "<C-x>", "<Plug>(copilot-dismiss)", { silent = true })
vim.keymap.set("n", "ZZ", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "o" }, "Z", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "b", "m", { noremap = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<A-j>", ":lnext<CR>", { silent = true, desc = "Location List Next" })
vim.keymap.set("n", "<A-k>", ":lprev<CR>", { silent = true, desc = "Location List Previous" })

vim.api.nvim_set_keymap("n", "<A-=>", ":bd!<CR>", { noremap = true, silent = true })

-- Global variables to store terminal window and buffer IDs
local term_win_id = nil

local term_buf_id = nil

---------------------------------------------------------------------
---harpoon keymaps---------------------------------------------------

vim.keymap.set("n", "<leader>ha", function()
	require("harpoon.mark").add_file()
end, { desc = "Harpoon Add File" })

vim.keymap.set("n", "<leader>hm", function()
	require("harpoon.ui").toggle_quick_menu()
end, { desc = "Harpoon Menu" })

--------free this keys for harpoon
vim.keymap.set("n", "<leader>>", ">>", { desc = "Indent Right" })
vim.keymap.set("v", "<leader>>", ">gv", { desc = "Indent Right (Visual)" })

vim.keymap.set("n", "<leader>]", "<C-]>", { desc = "Indent Left" })
vim.keymap.set("n", "<leader>[", "<C-[>", { desc = "Indent Left (Visual)" })
vim.keymap.set("n", "<leader>p", "<C-p>", { desc = "Indent Left (Visual)" })
vim.keymap.set("n", "<leader>o", "<C-o>", { desc = "Indent Left (Visual)" })

-- Map leader + < for indent left
vim.keymap.set("n", "<leader><", "<<", { desc = "Indent Left" })
vim.keymap.set("v", "<leader><", "<gv", { desc = "Indent Left (Visual)" })

-- Add this to your keymaps.lua
-- Add this to your keymaps.lua
vim.keymap.set("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Search Marks (Telescope)" })

local map = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<A-c>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "<A-c>", "<Esc>", opts)
vim.keymap.set("v", "<A-c>", "<Esc>", opts)
vim.keymap.set("t", "<A-c>", "<C-\\><C-n>", opts)

vim.keymap.set("n", "}", "<C-d>", opts)

vim.keymap.set("n", "{", "<C-u>", opts)

vim.keymap.set("n", "<C-d>", "}", { noremap = true, silent = true })

vim.keymap.set("n", "<C-e>", "{", { noremap = true, silent = true })

vim.keymap.set("n", "<C-x>", "<Plug>(matchup-%)", {})
vim.keymap.set("v", "<C-x>", "<Plug>(matchup-%)", {})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<A-left>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<A-right>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<A-down>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<A-up>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("i", "<C-x>", "<Plug>(copilot-dismiss)", { silent = true })
vim.keymap.set("n", "ZZ", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "o" }, "Z", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "b", "m", { noremap = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<A-j>", ":lnext<CR>", { silent = true, desc = "Location List Next" })
vim.keymap.set("n", "<A-k>", ":lprev<CR>", { silent = true, desc = "Location List Previous" })

vim.api.nvim_set_keymap("n", "<A-=>", ":bd!<CR>", { noremap = true, silent = true })

-- Global variables to store terminal window and buffer IDs
local term_win_id = nil

local term_buf_id = nil

---------------------------------------------------------------------
---harpoon keymaps---------------------------------------------------

vim.keymap.set("n", "<leader>ha", function()
	require("harpoon.mark").add_file()
end, { desc = "Harpoon Add File" })

vim.keymap.set("n", "<leader>hm", function()
	require("harpoon.ui").toggle_quick_menu()
end, { desc = "Harpoon Menu" })

--------free this keys for harpoon
vim.keymap.set("n", "<leader>>", ">>", { desc = "Indent Right" })
vim.keymap.set("v", "<leader>>", ">gv", { desc = "Indent Right (Visual)" })

vim.keymap.set("n", "<leader>]", "<C-]>", { desc = "Indent Left" })
vim.keymap.set("n", "<leader>[", "<C-[>", { desc = "Indent Left (Visual)" })
vim.keymap.set("n", "<leader>p", "<C-p>", { desc = "Indent Left (Visual)" })
vim.keymap.set("n", "<leader>o", "<C-o>", { desc = "Indent Left (Visual)" })

-- Map leader + < for indent left
vim.keymap.set("n", "<leader><", "<<", { desc = "Indent Left" })
vim.keymap.set("v", "<leader><", "<gv", { desc = "Indent Left (Visual)" })

-- Jump to first focusable floating window
function _G.focus_floating_window()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg.focusable and cfg.relative and cfg.relative ~= "" then
			vim.api.nvim_set_current_win(win)
			return
		end
	end
end

vim.keymap.set("n", "<A-f>", _G.focus_floating_window, { desc = "Focus floating window" })
----------------------------------
----------------------------------
-- Global variables to track state
_G.OpencodeBuf = nil
_G.OpencodePrevBuf = nil

-- vim.keymap.set({ "n", "t" }, "<A-v>", function()
-- 	local current_buf = vim.api.nvim_get_current_buf()
-- 	local opencode_buf = _G.OpencodeBuf
--
-- 	-- CASE 1: We are currently in OpenCode -> GO BACK
-- 	if opencode_buf and current_buf == opencode_buf then
-- 		local prev_buf = _G.OpencodePrevBuf
-- 		if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) then
-- 			-- Switch back to the previous buffer
-- 			vim.api.nvim_win_set_buf(0, prev_buf)
-- 		else
-- 			-- Fallback: If previous buffer was deleted, try the alternate buffer or next
-- 			pcall(vim.cmd, "b#")
-- 		end
-- 		return
-- 	end
--
-- 	-- CASE 2: We are in normal code -> OPEN OPENCODE
--
-- 	-- 1. Save current buffer so we can return to it
-- 	_G.OpencodePrevBuf = current_buf
--
-- 	-- 2. Check if OpenCode is already running in background
-- 	if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
-- 		-- Just switch to it
-- 		vim.api.nvim_win_set_buf(0, opencode_buf)
-- 	else
-- 		-- 3. Create a new buffer if it doesn't exist
-- 		-- (false, false) = not listed in :ls, not a scratch buffer
-- 		local new_buf = vim.api.nvim_create_buf(false, false)
-- 		_G.OpencodeBuf = new_buf
--
-- 		-- Switch to the new buffer first
-- 		vim.api.nvim_win_set_buf(0, new_buf)
--
-- 		-- IMPORTANT: Keep process alive when we switch away
-- 		vim.bo[new_buf].bufhidden = "hide"
--
-- 		-- Start the terminal
-- 		vim.fn.termopen("opencode", {
-- 			on_exit = function()
-- 				_G.OpencodeBuf = nil
-- 			end,
-- 		})
-- 	end
--
-- 	-- UI Cleanup
-- 	vim.cmd("startinsert")
-- 	vim.opt_local.number = false
-- 	vim.opt_local.relativenumber = false
-- 	vim.opt_local.signcolumn = "no"
-- end, { noremap = true, silent = true, desc = "Toggle OpenCode (Current Buffer)" })
----------------------------------
----------------------------------
----------------------------------
----------------------------------
----------------------------------
-- Define a global to hold the last image filename
vim.g.last_image_filename = vim.g.last_image_filename or "image.png"

vim.api.nvim_create_user_command("PasteImage", function()
	-- Use the last filename as the default
	local default = vim.g.last_image_filename
	local filename = vim.fn.input("Image filename: ", default)
	if filename == "" then
		print("❌ No filename provided.")
		return
	end

	-- Wrap the filename in quotes to handle spaces
	local cmd = 'xclip -selection clipboard -t image/png -o > "' .. filename .. '"'
	local result = vim.fn.system(cmd)

	-- Check if file is actually created and not empty
	local stat = vim.loop.fs_stat(filename)
	if stat and stat.size > 1 then
		-- Save this as the new default
		vim.g.last_image_filename = filename
		print("✅ Image saved as " .. filename)
	else
		print("❌ Failed to save image. Clipboard may not contain an image.")
	end
end, {})
----
----
----
----
--- split window
vim.keymap.set("n", "<leader>wo", function()
	-- Split the window vertically
	vim.cmd("vsplit")

	-- Optional: focus stays on original (left), move cursor back
	vim.cmd("wincmd h")
end, { noremap = true, silent = true, desc = "Vertical split (half screen)" })
------------------------------------
------------------------------------
------------------------------------
------------------------------------
local term_buf_id = nil
local term_win_id = nil

function ToggleBottomTerminal()
	-- determine "target" cwd: use current buffer's dir, else fallback to global cwd
	local bufn = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(bufn)
	local cwd = ""
	if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
		cwd = vim.fn.fnamemodify(bufname, ":p:h")
	else
		cwd = vim.fn.getcwd()
	end

	if term_win_id and vim.api.nvim_win_is_valid(term_win_id) then
		-- hide it if already visible
		vim.api.nvim_win_hide(term_win_id)
		term_win_id = nil
	else
		-- if the buffer exists, reuse it; otherwise create a new one
		if term_buf_id and vim.api.nvim_buf_is_valid(term_buf_id) then
			vim.cmd("botright new")
			vim.api.nvim_win_set_height(0, 10)
			vim.api.nvim_win_set_buf(0, term_buf_id)
		else
			vim.cmd("botright new")
			vim.api.nvim_win_set_height(0, 10)
			-- set local cwd of this window to the target dir, only if valid
			if cwd ~= "" and vim.fn.isdirectory(cwd) == 1 then
				vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
			end
			-- spawn a shell
			vim.cmd("term")
			term_buf_id = vim.api.nvim_get_current_buf()
		end

		-- remove any funky background highlights
		vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal,NormalNC:Normal")
		vim.cmd("startinsert")

		term_win_id = vim.api.nvim_get_current_win()
	end
end

-- map Alt-- to toggle
vim.api.nvim_set_keymap("n", "<A-->", [[:lua ToggleBottomTerminal()<CR>]], { noremap = true, silent = true })

-- Jump to first focusable floating window
function _G.focus_floating_window()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg.focusable and cfg.relative and cfg.relative ~= "" then
			vim.api.nvim_set_current_win(win)
			return
		end
	end
end

vim.keymap.set("n", "<A-f>", _G.focus_floating_window, { desc = "Focus floating window" })
----------------------------------
----------------------------------
----------------------------------
-- Key: Visual mode fix
vim.keymap.set("v", "<leader>cf", function()
	require("CopilotChat").ask("Fix this code", { selection = require("CopilotChat.select").visual })
end, { desc = "Copilot Fix" })

-- Custom "Smart Shift-Tab" logic
-- vim.keymap.set("i", "<S-Tab>", function()
-- 	if require("copilot.suggestion").is_visible() then
-- 		require("copilot.suggestion").accept()
-- 	else
-- 		-- If no suggestion, send a real Shift-Tab (usually un-indent)
-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
-- 	end
-- end, { desc = "Copilot Accept or Shift-Tab" })

-- Key: Visual mode explain
vim.keymap.set("v", "<leader>ce", function()
	require("CopilotChat").ask("Explain this code", { selection = require("CopilotChat.select").visual })
end, { desc = "Copilot Explain" })

vim.keymap.set("n", "<leader>co", function()
	-- Run the CopilotChat command
	vim.cmd("CopilotChat")
	-- Simulate pressing `i` after a short delay
	vim.defer_fn(function()
		vim.api.nvim_feedkeys("i", "n", false)
	end, 10) -- 10ms delay to ensure the window is ready
end, { noremap = true, silent = true, desc = "Open Copilot Chat and enter insert mode" })
----------------------------------
----------------------------------
----------------------------------
----------------------------------
----------------------------------
-- Define a global to hold the last image filename
vim.g.last_image_filename = vim.g.last_image_filename or "image.png"

vim.api.nvim_create_user_command("PasteImage", function()
	-- Use the last filename as the default
	local default = vim.g.last_image_filename
	local filename = vim.fn.input("Image filename: ", default)
	if filename == "" then
		print("❌ No filename provided.")
		return
	end

	-- Wrap the filename in quotes to handle spaces
	local cmd = 'xclip -selection clipboard -t image/png -o > "' .. filename .. '"'
	local result = vim.fn.system(cmd)

	-- Check if file is actually created and not empty
	local stat = vim.loop.fs_stat(filename)
	if stat and stat.size > 1 then
		-- Save this as the new default
		vim.g.last_image_filename = filename
		print("✅ Image saved as " .. filename)
	else
		print("❌ Failed to save image. Clipboard may not contain an image.")
	end
end, {})
----
----
----
----
--- split window
vim.keymap.set("n", "<leader>wo", function()
	-- Split the window vertically
	vim.cmd("vsplit")

	-- Optional: focus stays on original (left), move cursor back
	vim.cmd("wincmd h")
end, { noremap = true, silent = true, desc = "Vertical split (half screen)" })
------------------------------------
------------------------------------
------------------------------------
------------------------------------
local term_buf_id = nil
local term_win_id = nil

function ToggleBottomTerminal()
	-- determine "target" cwd: use current buffer's dir, else fallback to global cwd
	local bufn = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(bufn)
	local cwd = ""
	if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
		cwd = vim.fn.fnamemodify(bufname, ":p:h")
	else
		cwd = vim.fn.getcwd()
	end

	if term_win_id and vim.api.nvim_win_is_valid(term_win_id) then
		-- hide it if already visible
		vim.api.nvim_win_hide(term_win_id)
		term_win_id = nil
	else
		-- if the buffer exists, reuse it; otherwise create a new one
		if term_buf_id and vim.api.nvim_buf_is_valid(term_buf_id) then
			vim.cmd("botright new")
			vim.api.nvim_win_set_height(0, 10)
			vim.api.nvim_win_set_buf(0, term_buf_id)
		else
			vim.cmd("botright new")
			vim.api.nvim_win_set_height(0, 10)
			-- set local cwd of this window to the target dir, only if valid
			if cwd ~= "" and vim.fn.isdirectory(cwd) == 1 then
				vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
			end
			-- spawn a shell
			vim.cmd("term")
			term_buf_id = vim.api.nvim_get_current_buf()
		end

		-- remove any funky background highlights
		vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal,NormalNC:Normal")
		vim.cmd("startinsert")

		term_win_id = vim.api.nvim_get_current_win()
	end
end

-- map Alt-- to toggle
vim.api.nvim_set_keymap("n", "<A-->", [[:lua ToggleBottomTerminal()<CR>]], { noremap = true, silent = true })
