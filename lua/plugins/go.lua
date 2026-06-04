-- Go development plugins
return {
	-- ray-x/go.nvim: full Go tooling (test runner, code gen, linting, etc.)
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("go").setup({
				gofmt = "gofumpt",
				max_line_len = 120,
				-- Disabled: vim.lsp.codelens.enable() requires Neovim >= 0.10
				-- Remove this line once you upgrade to Neovim 0.10+
				lsp_codelens = false,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},

	-- gopher.nvim: Go productivity helpers (struct tags, interface impl, if err)
	-- NOTE: After first install, open any .go file and run :GoInstallDeps once
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = true,
		keys = {
			-- Struct tag generation
			{ "<leader>gsj", "<cmd>GoTagAdd json<CR>",  ft = "go", desc = "Go: Add JSON struct tags" },
			{ "<leader>gsy", "<cmd>GoTagAdd yaml<CR>",  ft = "go", desc = "Go: Add YAML struct tags" },
			{ "<leader>gsb", "<cmd>GoTagAdd bson<CR>",  ft = "go", desc = "Go: Add BSON struct tags" },
			{ "<leader>gsd", "<cmd>GoTagRm json<CR>",   ft = "go", desc = "Go: Remove JSON struct tags" },
			-- Error and interface helpers
			{ "<leader>gie", "<cmd>GoIfErr<CR>",        ft = "go", desc = "Go: Add if err != nil block" },
			{ "<leader>gim", "<cmd>GoImpl<CR>",         ft = "go", desc = "Go: Implement interface" },
			-- Doc comments
			{ "<leader>gdc", "<cmd>GoCmt<CR>",          ft = "go", desc = "Go: Add doc comment" },
		},
	},
}
