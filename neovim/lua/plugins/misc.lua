-- Simple plugins without complex configuration
return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		"othree/html5.vim",
		ft = { "html", "ejs" },
	},

	{
		"norcalli/nvim-colorizer.lua",
		event = "VeryLazy", -- lazy-load on BufReadPre or VeryLazy
		config = function()
			require("colorizer").setup()
		end,
	},

	{
		"andymass/vim-matchup",
		event = "VeryLazy",
	},

	{
		"ekalinin/Dockerfile.vim",
		ft = "dockerfile",
	},

	{
		"stephpy/vim-yaml",
		ft = "yaml",
	},

	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = { "markdown" },
		config = function()
			vim.g.mkdp_auto_start = 0
		end,
	},

	{
		"mattn/emmet-vim",
		ft = { "html", "css", "scss", "javascriptreact", "typescriptreact", "ejs" },
		init = function()
			-- Optional: Customize for Next.js JSX/TSX (e.g., className instead of class)
			vim.g.user_emmet_settings = {
				typescriptreact = {
					extends = "jsx",
					attributes = {
						["className"] = "class", -- Expand class to className
					},
				},
				javascriptreact = {
					extends = "jsx",
					attributes = {
						["className"] = "class",
					},
				},
			}
		end,
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	{
		"mbbill/undotree",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" } },
	},

	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function()
			require("crates").setup({
				completion = {
					cmp = {
						enabled = true,
					},
				},
			})
			require("cmp").setup.buffer({
				sources = { { name = "crates" } },
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"elentok/format-on-save.nvim",
		config = function()
			require("format-on-save").setup({
				formatters = {
					{
						filename_pattern = { "*.tsx", "*.jsx", "*.ts", "*.js" },
						command = "eslint --fix --quiet",
						-- For projects with local ESLint installation:
						command = "./node_modules/.bin/eslint --fix --quiet $FILE_PATH",
					},
				},
				-- Optional: Enable format on save by default
				format_on_save = true,
			})
		end,
	},
}
