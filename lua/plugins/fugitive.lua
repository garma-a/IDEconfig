return {
	"tpope/vim-fugitive",
	cmd = { "G", "Git" },
	keys = {
		{ "<leader>gs", "<cmd>vertical Git<cr>", desc = "Git Status" },
		{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
		{ "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
		{ "<leader>gl", "<cmd>Git pull<cr>", desc = "Git Pull" },
		{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
	},
	config = function()
		local group = vim.api.nvim_create_augroup("FugitiveCustom", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "fugitive",
			callback = function()
				-- Helper function to safely "steal" a plugin's mapping
				local function steal_key(original_key, new_key)
					local map = vim.fn.maparg(original_key, "n", false, true)
					if map and map.rhs then
						local rhs = map.rhs
						-- FIX THE CRASH: Replace <SID> with <SNR> + script_id
						if map.sid and rhs:lower():find("<sid>") then
							rhs = rhs:gsub("<[sS][iI][dD]>", "<SNR>" .. map.sid .. "_")
						end
						-- Map the new key to the sanitized action
						vim.keymap.set("n", new_key, rhs, { buffer = true, remap = true, silent = true })
					end
				end

				-- 1. STEAL THE ACTIONS (Before we overwrite the keys)
				-- Map 's' to whatever '-' used to do (Stage)
				steal_key("-", "s")
				-- Map 'Tab' to whatever '=' used to do (Inline Diff)
				steal_key("=", "<Tab>")

				-- 2. OVERWRITE NAVIGATION
				local opts = { buffer = true, remap = false, silent = true, nowait = true }
				vim.keymap.set("n", "-", "k", opts) -- Up
				vim.keymap.set("n", "=", "j", opts) -- Down

				-- 3. OTHER SHORTCUTS
				-- Use remap=true so 'cc' opens the fugitive commit window
				vim.keymap.set("n", "<leader>cc", "cc", { buffer = true, remap = true })
			end,
		})
	end,
}
