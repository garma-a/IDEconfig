return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"zbirenbaum/copilot.lua",
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-4.5", -- Exact identifier from the debug output
					},
				},
				inline = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-4.5",
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
			desc = "Toggle Chat Sidebar",
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
