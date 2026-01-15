return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Define the custom Oil bar function
			CustomOilBar = function()
				local path = vim.fn.expand("%")
				path = path:gsub("oil://", "")
				return "  " .. vim.fn.fnamemodify(path, ":%")
			end

			-- Setup Oil with custom options
			require("oil").setup({
				keymaps = {
					["<C-h>"] = false,
					["<C-l>"] = false,
					["<C-k>"] = false,
					["<C-j>"] = false,
					["<M-h>"] = "actions.select_split",
					["<A-s>"] = function()
						vim.cmd("bd")
					end,
					["-"] = "actions.parent", -- Move up (go to parent directory)
					["-"] = function()
						vim.cmd("normal! k")
					end,
					-- Map '=' to move down (simulate pressing 'j')
					["="] = function()
						vim.cmd("normal! j")
					end,
				},
				win_options = {
					wrap = false,
					signcolumn = "no",
					winbar = "%{v:lua.CustomOilBar()}",
				},
				view_options = {
					show_hidden = true,
				},
				skip_confirm_for_simple_edits = true,
			})

			-- Keymap to toggle Oil with '_'
			vim.keymap.set("n", "<A-s>", "<CMD>Oil<CR>", { desc = "Toggle Oil" })
		end,
	},
}