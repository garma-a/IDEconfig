return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"zbirenbaum/copilot.lua",
	},
	config = function()
		require("codecompanion").setup({
			strategies = {},
			display = {
				chat = {
					window = {
						layout = "float", -- Use floating window instead of sidebar
						width = 1,
						height = 1,
						border = "rounded",
					},
				},
			},
		})
	end,
	keys = {
		{
			"<M-v>",
			"<cmd>CodeCompanionChat Toggle<cr>",
			mode = { "n", "v" },
			desc = "Toggle Chat Buffer",
		},
		{
			"<M-a>",
			"<cmd>CodeCompanion<cr>",
			mode = { "n", "v" },
			desc = "Inline Assistant",
		},
		{
			"<M-e>",
			"<cmd>CodeCompanionChat Add<cr>",
			mode = "v",
			desc = "Send selection to Chat",
		},
	},
}
