-- Debugger: DAP + UI + Virtual Text
-- Provides: breakpoints, step execution, variable inspection, call stack
-- Languages: Go (via Delve) and TypeScript/JavaScript (via js-debug-adapter)
return {
	-- 1. nvim-dap-ui: The visual debugger interface (scopes, stacks, breakpoints, REPL)
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		keys = {
			-- Toggle the full debugger UI panel
			{
				"<leader>dd",
				function()
					require("dapui").toggle()
				end,
				desc = "Debug: Toggle UI",
			},
			-- Hover/eval: inspect a variable under cursor (normal and visual mode)
			{
				"<leader>dh",
				function()
					require("dapui").eval()
				end,
				desc = "Debug: Hover/Eval expression",
				mode = { "n", "v" },
			},
		},
		opts = {
			-- Layout: left panel = variables + call stack + breakpoints, bottom = REPL
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.50 }, -- Local variables in scope
						{ id = "stacks", size = 0.30 }, -- Call stack (what called what)
						{ id = "breakpoints", size = 0.20 }, -- List of all breakpoints
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 1.0 }, -- Debug console / REPL
					},
					size = 10,
					position = "bottom",
				},
			},
			floating = {
				border = "rounded",
			},
			controls = {
				enabled = true,
				element = "repl",
			},
		},
		config = function(_, opts)
			local dapui = require("dapui")
			dapui.setup(opts)

			-- Auto-open UI when a debug session starts
			-- Auto-close UI when the session ends
			local dap = require("dap")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- 2. Inline virtual text: show variable values next to each line while stepping
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			commented = true, -- Display as a comment so it's visually subtle
			highlight_changed_variables = true, -- Highlight values that just changed
			show_stop_reason = true, -- Show why execution stopped
		},
	},

	-- 3. Go debugger: auto-configures Delve, zero manual setup needed
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = { "mfussenegger/nvim-dap" },
		opts = {
			-- Delve settings (leave defaults; they work out of the box)
			dap_configurations = {
				{
					-- Debug the current Go file / package
					type = "go",
					name = "Debug",
					request = "launch",
					program = "${file}",
				},
				{
					-- Debug the whole module (from project root)
					type = "go",
					name = "Debug Package",
					request = "launch",
					program = "${fileDirname}",
				},
			},
		},
	},

	-- 4. Mason DAP: auto-installs js-debug-adapter for TypeScript/JavaScript
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			ensure_installed = vim.env.IDE_SETUP == "1" and {} or { "js" }, -- js = js-debug-adapter (handles TS, JS, Node)
			handlers = {}, -- Use default handler for automatic adapter configuration
		},
	},

	-- 5. Core nvim-dap: already installed as go.nvim dependency — we just add keymaps
	{
		"mfussenegger/nvim-dap",
		keys = {
			-- ── Breakpoints ─────────────────────────────────────────────────────────
			{
				"<leader>dt",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>dT",
				function()
					-- Conditional breakpoint: only stops when the expression is true
					vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
						if condition then
							require("dap").set_breakpoint(condition)
						end
					end)
				end,
				desc = "Debug: Conditional Breakpoint",
			},

			-- ── Session control ──────────────────────────────────────────────────────
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start / Continue",
			},
			{
				"<leader>dx",
				function()
					require("dap").terminate()
				end,
				desc = "Debug: Stop / Terminate",
			},
			{
				"<leader>dr",
				function()
					require("dap").restart()
				end,
				desc = "Debug: Restart",
			},

			-- ── Step controls ────────────────────────────────────────────────────────
			{
				"<leader>dn",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over (Next line)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into (follow function call)",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out (return from function)",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_back()
				end,
				desc = "Debug: Step Back",
			},

			-- ── Inspect ──────────────────────────────────────────────────────────────
			{
				"<leader>dR",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Debug: Toggle REPL",
			},
		},
		config = function()
			-- ── Signs: visual indicators in the gutter ───────────────────────────────
			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "◆",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "●",
				texthl = "DapBreakpointRejected",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "◉",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = "▶",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "",
			})

			-- ── Highlight colours ────────────────────────────────────────────────────
			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" }) -- Red dot
			vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5a800" }) -- Yellow diamond
			vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888" }) -- Grey (invalid bp)
			vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" }) -- Blue circle
			vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" }) -- Green arrow
			vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d" }) -- Subtle green background

			-- ── TypeScript / JavaScript adapter (Node.js via js-debug-adapter) ───────
			-- Mason installs js-debug-adapter; we just point dap at it.
			local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
			local js_debug_exec = js_debug_path .. "/js-debug/src/dapDebugServer.js"

			for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
				require("dap").configurations[lang] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file (Node.js)",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
				}
			end

			-- Register the js-debug-adapter with nvim-dap
			require("dap").adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { js_debug_exec, "${port}" },
				},
			}
		end,
	},
}
