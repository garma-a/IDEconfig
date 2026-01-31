return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang-format" }, -- Added clang-format for C files
				cpp = { "clang-format" }, -- Added clang-format for C++ files
				python = { "black" }, -- Added black for Python files
				sql = { "pg_format" },
				zig = { "zigfmt" }, -- Zig built-in formatter
				-- Prisma formatting is handled by the language server automatically
			},
			formatters = {
				pg_format = {
					prepend_args = {
						"--keyword-case",
						"upper",
						"--spaces",
						"2",
					},
				},
				zigfmt = {
					command = "zig",
					args = { "fmt", "--stdin" },
					stdin = true,
				},
				-- Prisma formatting is handled by the language server
			},
		},
	},
}
