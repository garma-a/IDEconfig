-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local cloned = false
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	cloned = true
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
-- Pin the manager before loading it; otherwise its first install rewrites its own pin.
if cloned or (vim.env.IDE_SETUP == "1" and vim.env.IDE_VERIFY ~= "1") then
	local config_dir = vim.env.IDE_SETUP_REPO or vim.fn.stdpath("config")
	local lock = vim.json.decode(table.concat(vim.fn.readfile(config_dir .. "/lazy-lock.json"), "\n"))
	local pin = assert(lock["lazy.nvim"], "lazy.nvim pin missing").commit
	local function git(args)
		local out = vim.fn.system(vim.list_extend({ "git", "-C", lazypath }, args))
		return vim.v.shell_error == 0, out
	end
	local _, head = git({ "rev-parse", "HEAD" })
	if vim.trim(head) ~= pin then
		local present = git({ "cat-file", "-e", pin .. "^{commit}" })
		if not present then
			local ok, out = git({ "fetch", "origin", pin })
			assert(ok, "Cannot fetch pinned lazy.nvim: " .. out)
		end
		local ok, out = git({ "checkout", "--detach", pin })
		assert(ok, "Cannot restore pinned lazy.nvim: " .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.cmd([[highlight! clear CursorLine]])

-- Setup lazy.nvim with the plugins directory
require("lazy").setup("plugins", {
	install = { missing = vim.env.IDE_VERIFY ~= "1" },
	checker = { enabled = false },
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})