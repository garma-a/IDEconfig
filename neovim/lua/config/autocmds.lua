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
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		vim.cmd("GoFmt")
	end,
})

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
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.ejs",
	callback = function()
		vim.bo.filetype = "html"
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.zig",
	callback = function()
		require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
	end,
})
