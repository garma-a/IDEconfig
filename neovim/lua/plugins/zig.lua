return {
	"ziglang/zig.vim",
	ft = { "zig", "zir" },
	config = function()
		-- Enable automatic formatting on save
		vim.g.zig_fmt_autosave = 1
	end,
}
