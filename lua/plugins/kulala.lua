return {
	"mistweaverco/kulala.nvim",
	keys = {
		-- { "<leader>Rs", desc = "Send request" },
		-- { "<leader>Ra", desc = "Send all requests" },
		-- { "<leader>Rb", desc = "Open scratchpad" },
	},
	ft = { "http", "rest" },
	opts = {},
	config = function(_, opts)
		require("kulala").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "http", "rest" },
			callback = function(event)
				vim.keymap.set("n", "<CR>", function()
					require("kulala").run()
				end, { buffer = event.buf, silent = true, desc = "Execute HTTP Request" })

				vim.keymap.set("n", "<S-CR>", function()
					require("kulala").jump_next()
				end, { buffer = event.buf, silent = true, desc = "Next Request" })

				vim.keymap.set("n", "<C-CR>", function()
					require("kulala").jump_prev()
				end, { buffer = event.buf, silent = true, desc = "Prev Request" })
				vim.keymap.set("n", "<leader>rm", function()
					require("kulala").search()
				end, { desc = "Request Menu (Search)" })
			end,
		})
	end,
}
