return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"javascript",
				"typescript",
				"python",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"c_sharp",
				"go", -- For Go (since you use gopls)
				"gomod", -- For Go modules
				"gotmpl", -- For Go templates
				"dockerfile", -- For Dockerfiles (since you use dockerls)
				"yaml", -- For YAML (since you use yamlls)
				"sql", -- For SQL (since you use sqlls)
				"css", -- For CSS (since you use cssls)
				"scss",
				"prisma", -- For Prisma schema files
				"embedded_template", -- For EJS files
				"zig", -- For Zig programming language
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
			matchup = {
				enable = true,
			},
		},
	},
}
