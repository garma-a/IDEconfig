vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name == "tsserver" then
			-- Next.js specific navigation
			vim.keymap.set("n", "gd", function()
				require("telescope.builtin").lsp_definitions({ jump_type = "never" })
			end, { buffer = args.buf, desc = "Goto Definition (TS)" })

			-- Component navigation
			vim.keymap.set(
				"n",
				"<leader>cc",
				"<cmd>Telescope find_files cwd=./components<CR>",
				{ desc = "Find Components" }
			)
			vim.keymap.set("n", "<leader>cp", "<cmd>Telescope find_files cwd=./pages<CR>", { desc = "Find Pages" })
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.go",
-- 	callback = function()
-- 		vim.cmd("GoFmt")
-- 	end,
-- })

-- Format Zig files on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.zig",
	callback = function()
		require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
	end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "Dockerfile", "*.dockerfile" },
	callback = function()
		vim.bo.filetype = "dockerfile"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.prisma",
	callback = function()
		vim.bo.filetype = "prisma"
	end,
})

-- Make Neovim treat .ejs as HTML
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- 	pattern = "*.ejs",
-- 	callback = function()
-- 		vim.bo.filetype = "html"
-- 	end,
-- })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.zig",
	callback = function()
		require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
	end,
})

-- Custom Quickfix/Location List Behavior
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }

		-- Map - and = to move up and down in the list
		vim.keymap.set("n", "-", "k", opts)
		vim.keymap.set("n", "=", "j", opts)

		-- Auto-preview on cursor move
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = event.buf,
			callback = function()
				-- Get window info to determine if it's loclist or qflist
				local winid = vim.api.nvim_get_current_win()
				local wininfo = vim.fn.getwininfo(winid)
				if not wininfo or #wininfo == 0 then
					return
				end

				local is_loclist = wininfo[1].loclist == 1
				local items
				if is_loclist then
					items = vim.fn.getloclist(0, { items = 0 }).items
				else
					items = vim.fn.getqflist({ items = 0 }).items
				end

				-- Get current item
				local idx = vim.fn.line(".")
				local item = items[idx]

				if not item or not item.bufnr or item.bufnr == 0 then
					return
				end

				-- Preview logic
				pcall(function()
					-- Go to the previous window (target)
					vim.cmd("wincmd p")
					local target_win = vim.api.nvim_get_current_win()

					-- If we are still in the QF window, do nothing (no other window to preview in)
					if target_win == winid then
						return
					end

					-- Switch buffer and cursor in target window
					if vim.api.nvim_buf_is_valid(item.bufnr) then
						vim.api.nvim_win_set_buf(target_win, item.bufnr)
						vim.api.nvim_win_set_cursor(target_win, { item.lnum, math.max(0, item.col - 1) })
						-- Center the view
						vim.cmd("normal! zz")
					end

					-- Return focus to the Quickfix window
					vim.api.nvim_set_current_win(winid)
				end)
			end,
		})
	end,
})

