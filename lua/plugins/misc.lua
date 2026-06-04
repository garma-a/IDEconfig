-- Miscellaneous small plugins
return {
	-- Detect tabstop and shiftwidth automatically from file context
	"tpope/vim-sleuth",

	-- HTML5 syntax for .html / .ejs files
	{
		"othree/html5.vim",
		ft = { "html", "ejs" },
	},

	-- Color code highlighting (#fff, rgb(), hsl(), etc.)
	-- NOTE: Using the actively maintained NvChad fork (norcalli/nvim-colorizer is abandoned)
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = false, -- Disable named colors (e.g. "Blue") for performance
				css = true,
				tailwind = true,
			},
		},
	},

	-- Bracket/tag matching and motions
	{
		"andymass/vim-matchup",
		event = "VeryLazy",
	},

	-- Markdown live preview in browser
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = { "markdown" },
		config = function()
			vim.g.mkdp_auto_start = 0
		end,
	},

	-- Emmet HTML/CSS expansion
	{
		"mattn/emmet-vim",
		ft = { "html", "css", "scss", "javascriptreact", "typescriptreact", "ejs" },
		init = function()
			vim.g.user_emmet_settings = {
				typescriptreact = {
					extends = "jsx",
					attributes = { ["className"] = "class" },
				},
				javascriptreact = {
					extends = "jsx",
					attributes = { ["className"] = "class" },
				},
			}
		end,
	},

	-- Auto-close brackets and quotes
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Visual undo tree browser
	{
		"mbbill/undotree",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" } },
	},

	-- Cargo.toml: crate version completion and info
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function()
			require("crates").setup({
				completion = { cmp = { enabled = true } },
			})
			require("cmp").setup.buffer({ sources = { { name = "crates" } } })
		end,
	},

	-- Auto-close and rename HTML/JSX/TSX tags
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	-- REMOVED: elentok/format-on-save.nvim  → conflicts with conform.nvim (both ran on JS/TS saves)
	-- REMOVED: stephpy/vim-yaml              → Treesitter yaml grammar is strictly better
	-- REMOVED: ekalinin/Dockerfile.vim       → Treesitter dockerfile grammar is strictly better
}
