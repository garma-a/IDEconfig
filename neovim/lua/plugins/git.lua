return {
	{ -- gitsigns
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			-- Harpoon setup (v1 style)
			require("harpoon").setup({
				global_settings = {
					enter_on_sendcmd = true,
					mark_branch = true,
				},
			})

			-- terminal module from Harpoon v1
			-- local term = require("harpoon.term")
			--
			-- local function get_current_working_directory()
			-- 	local bufn = vim.api.nvim_get_current_buf()
			-- 	local bufname = vim.api.nvim_buf_get_name(bufn)
			-- 	local cwd = ""
			-- 	if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
			-- 		cwd = vim.fn.fnamemodify(bufname, ":p:h")
			-- 	else
			-- 		cwd = vim.fn.getcwd()
			-- 	end
			-- 	return cwd
			-- end
			--
			-- -- Track terminals and previous file buffer
			-- local harpoon_term_bufs = {} -- term_num -> bufid
			-- local harpoon_prev_bufs = {} -- term_num -> file-bufid
			-- local last_file_buf = nil -- last *non-terminal* buffer
			--
			-- local function is_harpoon_terminal_buf(buf)
			-- 	for _, tbuf in pairs(harpoon_term_bufs) do
			-- 		if tbuf == buf then
			-- 			return true
			-- 		end
			-- 	end
			-- 	return false
			-- end
			--
			-- local function toggle_harpoon_terminal(term_num)
			-- 	local cur_buf = vim.api.nvim_get_current_buf()
			--
			-- 	-- If we are already in this terminal -> go back to its previous file buffer
			-- 	if harpoon_term_bufs[term_num] and cur_buf == harpoon_term_bufs[term_num] then
			-- 		local prev = harpoon_prev_bufs[term_num] or last_file_buf
			-- 		if prev and vim.api.nvim_buf_is_loaded(prev) then
			-- 			vim.api.nvim_set_current_buf(prev)
			-- 		else
			-- 			vim.cmd("b#")
			-- 		end
			-- 		return
			-- 	end
			--
			-- 	-- We are not in this terminal -> go to it
			--
			-- 	-- If we're currently in a *file* buffer, update last_file_buf and this term's prev
			-- 	if not is_harpoon_terminal_buf(cur_buf) then
			-- 		last_file_buf = cur_buf
			-- 		harpoon_prev_bufs[term_num] = cur_buf
			-- 	else
			-- 		-- We are in some other terminal:
			-- 		-- if this term has no prev yet, fall back to last_file_buf (the last real file)
			-- 		if not harpoon_prev_bufs[term_num] then
			-- 			harpoon_prev_bufs[term_num] = last_file_buf
			-- 		end
			-- 	end
			--
			-- 	-- Jump to the terminal
			-- 	term.gotoTerminal(term_num)
			--
			-- 	-- Record this terminal's buffer
			-- 	harpoon_term_bufs[term_num] = vim.api.nvim_get_current_buf()
			--
			-- 	-- Set working directory inside terminal (optional)
			-- 	local cwd = get_current_working_directory()
			-- 	if cwd ~= "" and vim.fn.isdirectory(cwd) == 1 then
			-- 		local escaped_cwd = vim.fn.fnameescape(cwd)
			-- 		term.sendCommand(term_num, "cd " .. escaped_cwd .. " && cls\n")
			-- 	end
			-- end
			--
			-- ------------------------------------------------------------------
			-- -- Harpoon file mappings
			-- ------------------------------------------------------------------
			-- vim.keymap.set("n", "<leader>ha", function()
			-- 	require("harpoon.mark").add_file()
			-- end, { desc = "Harpoon Add File" })
			--
			-- vim.keymap.set("n", "<leader>hm", function()
			-- 	require("harpoon.ui").toggle_quick_menu()
			-- end, { desc = "Harpoon Menu" })
			--
			-- -- Free these keys then reuse them for harpoon navigation
			-- vim.keymap.set("n", "<leader>>", ">>", { desc = "Indent Right" })
			-- vim.keymap.set("v", "<leader>>", ">gv", { desc = "Indent Right (Visual)" })
			--
			-- vim.keymap.set("n", "<leader><", "<<", { desc = "Indent Left" })
			-- vim.keymap.set("v", "<leader><", "<gv", { desc = "Indent Left (Visual)" })
			--
			-- vim.keymap.set("n", "<leader>]", "<C-]>", { desc = "Indent Left" })
			-- vim.keymap.set("n", "<leader>[", "<C-[>", { desc = "Indent Left (Visual)" })
			-- vim.keymap.set("n", "<leader>p", "<C-p>", { desc = "Indent Left (Visual)" })
			-- vim.keymap.set("n", "<leader>o", "<C-o>", { desc = "Indent Left (Visual)" })
			--
			-- -- Harpoon file navigation
			-- vim.keymap.set("n", ">", function()
			-- 	require("harpoon.ui").nav_next()
			-- end, { desc = "Harpoon Next" })
			--
			-- vim.keymap.set("n", "<", function()
			-- 	require("harpoon.ui").nav_prev()
			-- end, { desc = "Harpoon Previous" })
			--
			-- vim.keymap.set("n", "<C-]>", function()
			-- 	require("harpoon.ui").nav_file(1)
			-- end, { desc = "Go to Harpoon file 1" })
			--
			-- vim.keymap.set("n", "<C-[>", function()
			-- 	require("harpoon.ui").nav_file(2)
			-- end, { desc = "Go to Harpoon file 2" })
			--
			-- vim.keymap.set("n", "<C-p>", function()
			-- 	require("harpoon.ui").nav_file(3)
			-- end, { desc = "Go to Harpoon file 3" })
			--
			-- vim.keymap.set("n", "<C-o>", function()
			-- 	require("harpoon.ui").nav_file(4)
			-- end, { desc = "Go to Harpoon file 4" })
			--
			-- ------------------------------------------------------------------
			-- -- Harpoon terminal toggles
			-- ------------------------------------------------------------------
			-- vim.keymap.set("n", "<A-1>", function()
			-- 	toggle_harpoon_terminal(1)
			-- end, { noremap = true, silent = true })
			--
			-- vim.keymap.set("n", "<A-2>", function()
			-- 	toggle_harpoon_terminal(2)
			-- end, { noremap = true, silent = true })
			--
			-- vim.keymap.set("n", "<A-3>", function()
			-- 	toggle_harpoon_terminal(3)
			-- end, { noremap = true, silent = true })
			--
			-- vim.keymap.set("n", "<A-4>", function()
			-- 	toggle_harpoon_terminal(4)
			-- end, { noremap = true, silent = true })
			--
			-- vim.keymap.set("n", "<A-5>", function()
			-- 	toggle_harpoon_terminal(5)
			-- end, { noremap = true, silent = true })
		end,
	},
}
