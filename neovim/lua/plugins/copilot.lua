return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			require("CopilotChat").setup({
				model = "claude-sonnet-4.5",

				providers = {
					gemini = {
						url = "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions",
						get_headers = function()
							local api_key = os.getenv("GEMINI_API_KEY")
							if not api_key then
								vim.notify("GEMINI_API_KEY environment variable not set", vim.log.levels.ERROR)
								return {}
							end
							return {
								["Authorization"] = "Bearer " .. api_key,
								["Content-Type"] = "application/json",
							}
						end,
						models = {
							"gemini-2.5-pro",
							"gemini-2.5-flash",
						},
					},
				},
			})
		end,
	},

	{
		"github/copilot.vim",
		dependencies = {},
		event = "VimEnter",
		config = function()
			vim.g.copilot_no_tab_map = false
			vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
		end,
	},
}
