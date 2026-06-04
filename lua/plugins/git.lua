return {
	-- Git signs in the gutter (add/change/delete indicators)
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add          = { text = "+" },
				change       = { text = "~" },
				delete       = { text = "_" },
				topdelete    = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Harpoon v2: fast file pinning and navigation
	-- Migrated from v1 (unmaintained) to v2 — same UX, cleaner API
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon"):setup({
				settings = {
					save_on_toggle = true,   -- persist list when toggling menu
					sync_on_ui_close = true, -- sync to disk when closing menu
				},
			})
		end,
	},
}
