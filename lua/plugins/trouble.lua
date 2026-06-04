-- trouble.nvim: pretty diagnostics, references, quickfix, and location list
return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			modes = {
				-- Show workspace diagnostics (all files)
				diagnostics = { auto_close = false },
			},
		},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<CR>",
				desc = "Trouble: Workspace Diagnostics",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
				desc = "Trouble: Buffer Diagnostics",
			},
			{
				"<leader>xL",
				"<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
				desc = "Trouble: LSP References/Defs",
			},
			{
				"<leader>xq",
				"<cmd>Trouble qflist toggle<CR>",
				desc = "Trouble: Quickfix List",
			},
			{
				"<leader>xl",
				"<cmd>Trouble loclist toggle<CR>",
				desc = "Trouble: Location List",
			},
			-- Navigate Trouble items without leaving the panel
			{
				"[t",
				function()
					require("trouble").prev({ skip_groups = true, jump = true })
				end,
				desc = "Trouble: Previous item",
			},
			{
				"]t",
				function()
					require("trouble").next({ skip_groups = true, jump = true })
				end,
				desc = "Trouble: Next item",
			},
		},
	},
}
