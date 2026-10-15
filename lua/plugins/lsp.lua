-- Native Neovim LSP root callbacks receive a buffer and an on_dir callback.
local function root_for(patterns)
	return function(bufnr, on_dir)
		local filename = vim.api.nvim_buf_get_name(bufnr)
		on_dir(require("lspconfig.util").root_pattern(unpack(patterns))(filename) or vim.fn.getcwd())
	end
end

return {
	-- LSP Plugins
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "j-hui/fidget.nvim", opts = {} },

			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local servers = {
				html = {
					filetypes = { "html", "ejs" }, -- Add EJS support
				},
				cssls = {},
				gopls = {
					settings = {
						gopls = {
							usePlaceholders = true,
							completeUnimported = true,
						},
					},
				},

				yamlls = {},
				dockerls = {},

				-- ✅ FIXED: Changed from 'tsserver' to 'ts_ls' and added single_file_support
								ts_ls = {
					cmd = { "tsc", "--lsp", "--stdio" },
					single_file_support = true,
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
						print("ts_ls attached to buffer " .. bufnr)
					end,
					settings = {
						typescript = {
							preferences = {
								importModuleSpecifierPreference = "project-relative",
							},
							experimental = {
								enableProjectDiagnostics = true,
							},
						},
						javascript = {
							preferences = {
								importModuleSpecifierPreference = "project-relative",
							},
						},
					},
					filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
				},


				tailwindcss = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"svelte",
						"vue",
					},
					init_options = {
						userLanguages = {
							typescriptreact = "typescript",
							javascriptreact = "javascript",
						},
					},
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									"tw`([^`]*)",
									"className=\\\\s*[\\\"']([^\\\"']*)",
									"class:\\\\s*[\\\"']([^\\\"']*)",
									"([\\\\w-]+)=\\\\s*[\\\"']([^\\\"']*)", -- For styled-components-like syntax
								},
							},
						},
					},
				},

				prismals = {
					cmd = { "prisma-language-server", "--stdio" },
					filetypes = { "prisma" },
					root_dir = root_for({ "schema.prisma", ".git" }),
				},
				csharp_ls = {
					filetypes = { "cs" },
					root_dir = root_for({ "*.sln", "*.csproj", ".git" }),
				},
				zls = {
					cmd = { "zls" },
					filetypes = { "zig", "zir" },
					root_dir = root_for({ "zls.json", "build.zig", ".git" }),
					settings = {
						zls = {
							enable_snippets = true,
							enable_autofix = true,
							enable_semantic_tokens = true,
							enable_inlay_hints = true,
							inlay_hints_show_builtin = true,
							inlay_hints_exclude_single_argument = true,
							warn_style = true,
							highlight_global_var_declarations = true,
						},
					},
				},

				-- GraphQL LSP: schema validation, type checking, hover docs, autocomplete
				graphql = {
					cmd = { "graphql-lsp", "server", "-m", "stream" },
					filetypes = {
						"graphql",
						"graphqls",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
					root_dir = root_for({
						".graphqlrc", ".graphqlrc.json", ".graphqlrc.yaml", ".graphqlrc.yml",
						".graphqlrc.js", ".graphqlrc.ts", "graphql.config.json", "graphql.config.js",
						"graphql.config.ts", "graphql.config.yaml", "graphql.config.yml", "package.json",
					}),
				},
			}

			require("mason-tool-installer").setup({
				ensure_installed = require("config.tools"),
				run_on_start = vim.env.IDE_SETUP ~= "1",
			})
			-- The locked mason-lspconfig v2 uses automatic_enable; handlers were removed.
			-- Configure explicitly so capabilities and per-server settings always apply.
			require("mason-lspconfig").setup({ automatic_enable = false })
			servers.eslint = {}
			servers.angularls = {}
			servers.pyright = {}
			servers.clangd = {}
			servers.lua_ls = {}
			for name, opts in pairs(servers) do
				vim.lsp.config(name, vim.tbl_deep_extend("force", { capabilities = capabilities }, opts))
				vim.lsp.enable(name)
			end

			-- Setup dbml-lsp manually since it's not natively supported by lspconfig out of the box
			local dbml_opts = {
				cmd = { "dbml-lsp", "--stdio" },
				filetypes = { "dbml" },
				root_dir = root_for({ ".git", "*.dbml" }),
				capabilities = capabilities,
			}
			vim.lsp.config("dbml", dbml_opts)
			vim.lsp.enable("dbml")
		end,
	},
}

