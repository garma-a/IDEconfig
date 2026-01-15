return {
	"ray-x/go.nvim",
	dependencies = { -- Optional dependencies
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
		"mfussenegger/nvim-dap",
	},
	config = function()
		require("go").setup({
			gofmt = "gofumpt",
			max_line_len = 120,
		})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()',
}
