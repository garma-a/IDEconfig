-- keymaps.lua — single source of truth, no duplicates
local opts = { noremap = true, silent = true }

------------------------------------------------------------------------
-- Escape / clear highlights
------------------------------------------------------------------------
vim.keymap.set("n", "<A-c>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "<A-c>", "<Esc>", opts)
vim.keymap.set("v", "<A-c>", "<Esc>", opts)
vim.keymap.set("t", "<A-c>", "<C-\\><C-n>", opts)

------------------------------------------------------------------------
-- LSP diagnostics
------------------------------------------------------------------------
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

------------------------------------------------------------------------
-- Key behavior remaps
-- (q → insert, m → macro record, b → mark)
------------------------------------------------------------------------
vim.keymap.set("n", "q", "i", opts)
vim.keymap.set("n", "Q", "I", opts)
vim.keymap.set("n", "m", "q", opts)
vim.keymap.set("n", "M", "q", opts)
vim.api.nvim_set_keymap("n", "b", "m", { noremap = true }) -- b now sets marks

-- End of line
vim.keymap.set({ "n", "o" }, "Z", "$", opts)
vim.keymap.set("n", "ZZ", "<Nop>", opts)

------------------------------------------------------------------------
-- Word motion remaps (e → forward word, w → back word)
------------------------------------------------------------------------
vim.keymap.set("n", "e", "w", opts)
vim.keymap.set("v", "e", "w", opts)
vim.keymap.set("n", "E", "W", opts)
vim.keymap.set("v", "E", "W", opts)
vim.keymap.set("n", "w", "b", opts)
vim.keymap.set("v", "w", "b", opts)
vim.keymap.set("n", "W", "B", opts)
vim.keymap.set("v", "W", "B", opts)

------------------------------------------------------------------------
-- Scroll remaps (} / { → half-page, C-d / C-e → paragraph)
------------------------------------------------------------------------
vim.keymap.set("n", "}", "<C-d>", opts)
vim.keymap.set("n", "{", "<C-u>", opts)
vim.keymap.set("n", "<C-d>", "}", opts)
vim.keymap.set("n", "<C-e>", "{", opts)

------------------------------------------------------------------------
-- Indentation
------------------------------------------------------------------------
vim.keymap.set("n", "+", "=", opts)
vim.keymap.set("n", "=", "+", opts)
vim.keymap.set("v", "+", "=", opts)
vim.keymap.set("v", "=", "+", opts)

-- Indent keep visual selection
vim.keymap.set("n", "<leader>>", ">>", { desc = "Indent right" })
vim.keymap.set("v", "<leader>>", ">gv", { desc = "Indent right (visual)" })
vim.keymap.set("n", "<leader><", "<<", { desc = "Indent left" })
vim.keymap.set("v", "<leader><", "<gv", { desc = "Indent left (visual)" })

------------------------------------------------------------------------
-- Bracket/tag matching (vim-matchup)
------------------------------------------------------------------------
vim.keymap.set("n", "<C-x>", "<Plug>(matchup-%)", {})
vim.keymap.set("v", "<C-x>", "<Plug>(matchup-%)", {})

------------------------------------------------------------------------
-- Terminal
------------------------------------------------------------------------
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

------------------------------------------------------------------------
-- Window navigation
------------------------------------------------------------------------
vim.keymap.set("n", "<A-left>",  "<C-w><C-h>", { desc = "Focus left window" })
vim.keymap.set("n", "<A-right>", "<C-w><C-l>", { desc = "Focus right window" })
vim.keymap.set("n", "<A-down>",  "<C-w><C-j>", { desc = "Focus lower window" })
vim.keymap.set("n", "<A-up>",    "<C-w><C-k>", { desc = "Focus upper window" })

-- Vertical split (cursor stays on original side)
vim.keymap.set("n", "<leader>wo", function()
	vim.cmd("vsplit")
	vim.cmd("wincmd h")
end, { noremap = true, silent = true, desc = "Vertical split" })

------------------------------------------------------------------------
-- Buffer management
------------------------------------------------------------------------
vim.keymap.set("n", "<A-=>", "<cmd>bd!<CR>", opts)

------------------------------------------------------------------------
-- Move lines in visual mode
------------------------------------------------------------------------
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

------------------------------------------------------------------------
-- Location list navigation
------------------------------------------------------------------------
vim.keymap.set("n", "<A-j>", ":lnext<CR>", { silent = true, desc = "Location list next" })
vim.keymap.set("n", "<A-k>", ":lprev<CR>", { silent = true, desc = "Location list prev" })

------------------------------------------------------------------------
-- Copilot
------------------------------------------------------------------------
vim.keymap.set("i", "<C-x>", "<Plug>(copilot-dismiss)", { silent = true })

------------------------------------------------------------------------
-- Go: quick if err != nil
------------------------------------------------------------------------
vim.keymap.set("n", "<leader>e", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

------------------------------------------------------------------------
-- Focus floating window (hover docs, etc.)
------------------------------------------------------------------------
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

------------------------------------------------------------------------
-- Harpoon (v2)
------------------------------------------------------------------------
vim.keymap.set("n", "<leader>ha", function()
	require("harpoon"):list():add()
end, { desc = "Harpoon: Add file" })

vim.keymap.set("n", "<leader>hm", function()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Menu" })

-- Navigate files 1-5 with Alt+number
vim.keymap.set("n", "<A-1>", function() require("harpoon"):list():select(1) end, opts)
vim.keymap.set("n", "<A-2>", function() require("harpoon"):list():select(2) end, opts)
vim.keymap.set("n", "<A-3>", function() require("harpoon"):list():select(3) end, opts)
vim.keymap.set("n", "<A-4>", function() require("harpoon"):list():select(4) end, opts)
vim.keymap.set("n", "<A-5>", function() require("harpoon"):list():select(5) end, opts)

-- Cycle through harpoon list
vim.keymap.set("n", ">", function() require("harpoon"):list():next() end, { desc = "Harpoon: Next" })
vim.keymap.set("n", "<", function() require("harpoon"):list():prev() end, { desc = "Harpoon: Prev" })

-- Legacy direct-slot nav (freed keys remapped via leader)
vim.keymap.set("n", "<leader>]", function() require("harpoon"):list():select(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>[", function() require("harpoon"):list():select(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>p", function() require("harpoon"):list():select(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>o", function() require("harpoon"):list():select(4) end, { desc = "Harpoon file 4" })

------------------------------------------------------------------------
-- Telescope
------------------------------------------------------------------------
vim.keymap.set("n", "<leader>sm", "<cmd>Telescope marks<CR>", { desc = "Search Marks" })

------------------------------------------------------------------------
-- Toggle bottom terminal (Alt + -)
------------------------------------------------------------------------
local term_buf_id = nil
local term_win_id = nil

local function get_buf_cwd()
	local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
		return vim.fn.fnamemodify(bufname, ":p:h")
	end
	return vim.fn.getcwd()
end

function ToggleBottomTerminal()
	if term_win_id and vim.api.nvim_win_is_valid(term_win_id) then
		vim.api.nvim_win_hide(term_win_id)
		term_win_id = nil
		return
	end

	vim.cmd("botright new")
	vim.api.nvim_win_set_height(0, 10)

	if term_buf_id and vim.api.nvim_buf_is_valid(term_buf_id) then
		vim.api.nvim_win_set_buf(0, term_buf_id)
	else
		local cwd = get_buf_cwd()
		if cwd ~= "" and vim.fn.isdirectory(cwd) == 1 then
			vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
		end
		vim.cmd("term")
		term_buf_id = vim.api.nvim_get_current_buf()
	end

	vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal,NormalNC:Normal")
	vim.cmd("startinsert")
	term_win_id = vim.api.nvim_get_current_win()
end

vim.keymap.set("n", "<A-->", ToggleBottomTerminal, { noremap = true, silent = true, desc = "Toggle bottom terminal" })

------------------------------------------------------------------------
-- Paste image from clipboard (xclip)
------------------------------------------------------------------------
vim.g.last_image_filename = vim.g.last_image_filename or "image.png"

vim.api.nvim_create_user_command("PasteImage", function()
	local filename = vim.fn.input("Image filename: ", vim.g.last_image_filename)
	if filename == "" then
		print("❌ No filename provided.")
		return
	end
	vim.fn.system('xclip -selection clipboard -t image/png -o > "' .. filename .. '"')
	local stat = vim.loop.fs_stat(filename)
	if stat and stat.size > 1 then
		vim.g.last_image_filename = filename
		print("✅ Image saved as " .. filename)
	else
		print("❌ Failed. Clipboard may not contain an image.")
	end
end, {})

------------------------------------------------------------------------
-- Saved directory search (SearchDirAdd / SearchDirList etc. live in init.lua)
------------------------------------------------------------------------
vim.keymap.set("n", "<leader>sf", function()
	require("telescope.builtin").find_files()
end, { desc = "[S]earch [F]iles in current directory" })

vim.keymap.set("n", "<leader>sG", function()
	require("telescope.builtin").live_grep()
end, { desc = "[S]earch by [G]rep in current directory" })

vim.keymap.set("n", "<leader>sa", "<cmd>SearchDirAdd<CR>",    { desc = "[S]earch Dir [A]dd" })
vim.keymap.set("n", "<leader>sR", "<cmd>SearchDirRemove<CR>", { desc = "[S]earch Dir [R]emove" })
vim.keymap.set("n", "<leader>sl", "<cmd>SearchDirList<CR>",   { desc = "[S]earch Dir [L]ist" })

------------------------------------------------------------------------
-- CopilotChat
------------------------------------------------------------------------
vim.keymap.set("v", "<leader>cf", function()
	require("CopilotChat").ask("Fix this code", { selection = require("CopilotChat.select").visual })
end, { desc = "Copilot: Fix selection" })

vim.keymap.set("v", "<leader>ce", function()
	require("CopilotChat").ask("Explain this code", { selection = require("CopilotChat.select").visual })
end, { desc = "Copilot: Explain selection" })

vim.keymap.set("n", "<leader>co", function()
	vim.cmd("CopilotChat")
	vim.defer_fn(function()
		vim.api.nvim_feedkeys("i", "n", false)
	end, 10)
end, { noremap = true, silent = true, desc = "Open CopilotChat" })
