-- autocmds.lua — all autocmds wrapped in augroups to prevent duplicates on re-source

------------------------------------------------------------------------
-- Yank highlight
------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text briefly",
	group = vim.api.nvim_create_augroup("MyHighlightYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

------------------------------------------------------------------------
-- Filetype detection
------------------------------------------------------------------------
local ft_group = vim.api.nvim_create_augroup("MyFiletypeDetect", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = ft_group,
	pattern = { "Dockerfile", "*.dockerfile" },
	callback = function()
		vim.bo.filetype = "dockerfile"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = ft_group,
	pattern = "*.prisma",
	callback = function()
		vim.bo.filetype = "prisma"
	end,
})

------------------------------------------------------------------------
-- Zig: format on save (single registration, no duplicate)
------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("MyZigFormat", { clear = true }),
	pattern = "*.zig",
	callback = function()
		require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
	end,
})

------------------------------------------------------------------------
-- LSP: per-client extra keymaps (ts_ls / Next.js navigation)
------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("MyLspExtras", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- NOTE: was "tsserver" (deprecated) — fixed to "ts_ls"
		if client and client.name == "ts_ls" then
			vim.keymap.set("n", "gd", function()
				require("telescope.builtin").lsp_definitions({ jump_type = "never" })
			end, { buffer = args.buf, desc = "Goto Definition (TS)" })

			vim.keymap.set("n", "<leader>cc",
				"<cmd>Telescope find_files cwd=./components<CR>",
				{ buffer = args.buf, desc = "Find Components" })

			vim.keymap.set("n", "<leader>cp",
				"<cmd>Telescope find_files cwd=./pages<CR>",
				{ buffer = args.buf, desc = "Find Pages" })
		end
	end,
})

------------------------------------------------------------------------
-- Quickfix / Location list: auto-preview on cursor move
------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("MyQuickfix", { clear = true }),
	pattern = "qf",
	callback = function(event)
		local qf_opts = { buffer = event.buf, silent = true }
		vim.keymap.set("n", "-", "k", qf_opts)
		vim.keymap.set("n", "=", "j", qf_opts)

		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = event.buf,
			callback = function()
				local winid = vim.api.nvim_get_current_win()
				local wininfo = vim.fn.getwininfo(winid)
				if not wininfo or #wininfo == 0 then
					return
				end

				local is_loclist = wininfo[1].loclist == 1
				local items = is_loclist
					and vim.fn.getloclist(0, { items = 0 }).items
					or vim.fn.getqflist({ items = 0 }).items

				local item = items[vim.fn.line(".")]
				if not item or not item.bufnr or item.bufnr == 0 then
					return
				end

				pcall(function()
					vim.cmd("wincmd p")
					local target_win = vim.api.nvim_get_current_win()
					if target_win == winid then
						return
					end
					if vim.api.nvim_buf_is_valid(item.bufnr) then
						vim.api.nvim_win_set_buf(target_win, item.bufnr)
						vim.api.nvim_win_set_cursor(target_win, { item.lnum, math.max(0, item.col - 1) })
						vim.cmd("normal! zz")
					end
					vim.api.nvim_set_current_win(winid)
				end)
			end,
		})
	end,
})

------------------------------------------------------------------------
-- CodeCompanion: restore scroll keymaps inside AI chat window
------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("MyCodeCompanion", { clear = true }),
	pattern = "codecompanion",
	callback = function()
		vim.keymap.set("n", "}", "<C-d>", { buffer = true, silent = true })
		vim.keymap.set("n", "{", "<C-u>", { buffer = true, silent = true })
	end,
})
