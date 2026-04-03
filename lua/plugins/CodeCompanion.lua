return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"zbirenbaum/copilot.lua",
	},
	config = function()
		require("codecompanion").setup({
			-- We skip the adapters block entirely to avoid the Copilot timeout bug.
			-- Instead, we force the model directly in the strategy.
			strategies = {
				chat = {
					adapter = {
						name = "copilot",
						model = "gpt-5-mini",
					},
				},
				inline = {
					adapter = {
						name = "copilot",
						model = "gpt-5-mini",
					},
				},
				agent = {
					adapter = {
						name = "copilot",
						model = "gpt-5-mini",
					},
				},
			},
			display = {
				chat = {
					window = {
						layout = "float",
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
