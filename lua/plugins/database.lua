-- Database client: vim-dadbod + UI + SQL autocompletion
return {
	{
		"tpope/vim-dadbod",
		cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection" },
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		config = function()
			-- Dadbod UI settings
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_auto_execute_table_helpers = 1
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"

			-- SQL autocomplete via cmp for sql/mysql/plsql buffers
			local group = vim.api.nvim_create_augroup("DadbodCompletion", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					require("cmp").setup.buffer({
						sources = {
							{ name = "vim-dadbod-completion" },
							{ name = "buffer" },
						},
					})
				end,
			})
		end,
		keys = {
			{ "<leader>dbu", "<cmd>DBUIToggle<CR>",        desc = "DB UI: Toggle" },
			{ "<leader>dba", "<cmd>DBUIAddConnection<CR>", desc = "DB UI: Add Connection" },
			{ "<leader>dbf", "<cmd>DBUIFindBuffer<CR>",    desc = "DB UI: Find Buffer" },
		},
	},
}
