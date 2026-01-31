return {
	{
		"prisma/vim-prisma",
		ft = "prisma",
		config = function()
			-- Enable Prisma syntax highlighting and features
			vim.g.prismaFoldEnable = 1
		end,
	},
}

