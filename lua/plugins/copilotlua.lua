return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<M-/>",
				},
			},
			panel = { enabled = false },
		})

		local suggestion = require("copilot.suggestion")

		vim.keymap.set("i", "<Tab>", function()
			if suggestion.is_visible() then
				suggestion.accept()
			else
				-- If no suggestion, send a real "Tab" key press
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end, { silent = true, desc = "Copilot Accept or Tab" })
	end,
}
