return {
	"tpope/vim-fugitive",
	cmd = { "G", "Git" },
	keys = {
		{ "<leader>gs", "<cmd>vertical Git<cr>", desc = "Git Status" },
		{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
		{ "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
		{ "<leader>gl", "<cmd>Git pull<cr>", desc = "Git Pull" },
		{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
		{ "<leader>gg", "<cmd>vertical Git log<cr>", desc = "Git Log" },
		{ "<leader>gr", "<cmd>vertical Git reflog<cr>", desc = "Git Reflog" },
		{ "<leader>gP", "<cmd>Git push --force-with-lease<cr>", desc = "Git Push (Force with Lease)" },
	},
	config = function()
		local group = vim.api.nvim_create_augroup("FugitiveCustom", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = { "fugitive", "git", "gitrebase" },
			callback = function()
				local function steal_key(original_key, new_key)
					local map = vim.fn.maparg(original_key, "n", false, true)
					if map and map.rhs then
						local rhs = map.rhs
						if map.sid and rhs:lower():find("<sid>") then
							rhs = rhs:gsub("<[sS][iI][dD]>", "<SNR>" .. map.sid .. "_")
						end
						vim.keymap.set("n", new_key, rhs, { buffer = true, remap = true, silent = true })
					end
				end

				-- 1. STEAL ACTIONS (Only if they exist in this buffer)
				steal_key("-", "s") -- Stage
				steal_key("=", "<Tab>") -- Diff

				-- 2. FORCE NAVIGATION (Absolute Overwrite)
				-- We use a function call to ensure it bypasses any other mapping logic
				local opts = { buffer = true, silent = true, nowait = true }

				vim.keymap.set("n", "-", "k", opts) -- Always Move Up
				vim.keymap.set("n", "=", "j", opts) -- Always Move Down

				-- 3. WINDOW COMMANDS
				vim.keymap.set("n", "<leader>cc", "cc", { buffer = true, remap = true })
				-- Allow 'q' to always close these vertical buffers easily
				vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
			end,
		})
	end,
}
