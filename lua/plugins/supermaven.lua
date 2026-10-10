return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = nil, -- Disable built-in handling so you can do it manually
			},
			ignore_filetypes = { cpp = true }, -- or { "cpp", }
			color = {
				suggestion_color = "#808080", -- Hint: Supermaven is often pink/purplish
				cterm = 244,
			},
			log_level = "info", -- set to "off" to disable logging completely
			disable_inline_completion = false, -- disables inline completion for use with cmp
			disable_keymaps = false, -- disables built in keymaps for more manual control
		})
		local suggestion = require("supermaven-nvim.completion_preview")

		vim.keymap.set("i", "<Tab>", function()
			if suggestion.has_suggestion() then
				-- Supermaven is visible? Accept it.
				-- We use vim.schedule to avoid textlock issues
				vim.schedule(function()
					suggestion.on_accept_suggestion()
				end)
			else
				-- No suggestion? Send a real "Tab" key press (indent)
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end, { silent = true, desc = "Supermaven Accept or Tab" })
	end,
}
