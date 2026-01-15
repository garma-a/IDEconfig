--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.g.python3_host_prog = "~/.neovim-venv/bin/python3"
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.guicursor = "n-v-c:block,i:block"
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 50
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
local map = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<A-c>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "<A-c>", "<Esc>", opts)
vim.keymap.set("v", "<A-c>", "<Esc>", opts)
vim.keymap.set("t", "<A-c>", "<C-\\><C-n>", opts) -- Exit terminal mode

-- Recording macros and behavior changes
vim.keymap.set("n", "m", "q", opts) -- Start recording macro with "m"
vim.keymap.set("n", "M", "q", opts)
vim.keymap.set("n", "Q", "I", opts) -- Make "Q" behave like "I"
vim.keymap.set("n", "q", "i", opts) -- Make "q" behave like "i"

-- Indentation and moving down
vim.keymap.set("n", "+", "=", opts) -- Use + for indentation
vim.keymap.set("n", "=", "+", opts) -- Use = for moving down
vim.keymap.set("v", "+", "=", opts) -- Use + for indentation
vim.keymap.set("v", "=", "+", opts) -- Use = for moving down

-- Word navigation
vim.keymap.set("n", "w", "b", opts) -- Move back with "w"
vim.keymap.set("v", "w", "b", opts)

vim.keymap.set("n", "e", "w", opts) -- Move forward with "e"
vim.keymap.set("v", "e", "w", opts)

vim.keymap.set("n", "}", "<C-d>", opts)

vim.keymap.set("n", "{", "<C-u>", opts)

vim.keymap.set("n", "<C-x>", "<Plug>(matchup-%)", {})
vim.keymap.set("v", "<C-x>", "<Plug>(matchup-%)", {})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<A-left>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<A-right>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<A-down>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<A-up>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("i", "<C-x>", "<Plug>(copilot-dismiss)", { silent = true })
vim.keymap.set("n", "ZZ", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "o" }, "Z", "$", { noremap = true, silent = true })
-- local marks
vim.api.nvim_set_keymap("n", "b", "m", { noremap = true })
--
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<A-j>", ":lnext<CR>", { silent = true, desc = "Location List Next" })
vim.keymap.set("n", "<A-k>", ":lprev<CR>", { silent = true, desc = "Location List Previous" })

vim.api.nvim_set_keymap("n", "<A-=>", ":bd!<CR>", { noremap = true, silent = true })

-- Global variables to store terminal window and buffer IDs
local term_win_id = nil

local term_buf_id = nil

---------------------------------------------------------------------
---harpoon keymaps---------------------------------------------------

vim.keymap.set("n", "<leader>ha", function()
	require("harpoon.mark").add_file()
end, { desc = "Harpoon Add File" })

vim.keymap.set("n", "<leader>hm", function()
	require("harpoon.ui").toggle_quick_menu()
end, { desc = "Harpoon Menu" })

--------free this keys for harpoon
vim.keymap.set("n", "<leader>>", ">>", { desc = "Indent Right" })
vim.keymap.set("v", "<leader>>", ">gv", { desc = "Indent Right (Visual)" })

vim.keymap.set("n", "<leader>]", "<C-]>", { desc = "Indent Left" })
vim.keymap.set("n", "<leader>[", "<C-[>", { desc = "Indent Left (Visual)" })
vim.keymap.set("n", "<leader>p", "<C-p>", { desc = "Indent Left (Visual)" })
vim.keymap.set("n", "<leader>o", "<C-o>", { desc = "Indent Left (Visual)" })

-- Map leader + < for indent left
vim.keymap.set("n", "<leader><", "<<", { desc = "Indent Left" })
vim.keymap.set("v", "<leader><", "<gv", { desc = "Indent Left (Visual)" })

vim.keymap.set("n", "<A-1>", function()
	require("harpoon.term").gotoTerminal(1)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-2>", function()
	require("harpoon.term").gotoTerminal(2)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-3>", function()
	require("harpoon.term").gotoTerminal(3)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-4>", function()
	require("harpoon.term").gotoTerminal(4)
end, { noremap = true, silent = true })

-------------------------------------

vim.keymap.set("n", ">", function()
	require("harpoon.ui").nav_next()
end, { desc = "Harpoon Next" })
vim.keymap.set("n", "<", function()
	require("harpoon.ui").nav_prev()
end, { desc = "Harpoon Previous" })

vim.keymap.set("n", "<C-]>", function()
	require("harpoon.ui").nav_file(1)
end, { desc = "Go to Harpoon window 1" })

vim.keymap.set("n", "<C-[>", function()
	require("harpoon.ui").nav_file(2)
end, { desc = "Go to Harpoon window 2" })

vim.keymap.set("n", "<C-p>", function()
	require("harpoon.ui").nav_file(3)
end, { desc = "Go to Harpoon window 3" })

vim.keymap.set("n", "<C-o>", function()
	require("harpoon.ui").nav_file(4)
end, { desc = "Go to Harpoon window 4" })

------------------------------------------------------------------------
------------------------------------------------------------------------

-- Jump to first focusable floating window
function _G.focus_floating_window()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg.focusable and cfg.relative and cfg.relative ~= "" then
			vim.api.nvim_set_current_win(win)
			return
		end
	end
end

vim.keymap.set("n", "<A-f>", _G.focus_floating_window, { desc = "Focus floating window" })
----------------------------------
----------------------------------
----------------------------------
-- Key: Visual mode fix
vim.keymap.set("v", "<leader>cf", function()
	require("CopilotChat").ask("Fix this code", { selection = require("CopilotChat.select").visual })
end, { desc = "Copilot Fix" })

-- Key: Visual mode explain
vim.keymap.set("v", "<leader>ce", function()
	require("CopilotChat").ask("Explain this code", { selection = require("CopilotChat.select").visual })
end, { desc = "Copilot Explain" })

vim.keymap.set("n", "<leader>co", function()
	-- Run the CopilotChat command
	vim.cmd("CopilotChat")
	-- Simulate pressing `i` after a short delay
	vim.defer_fn(function()
		vim.api.nvim_feedkeys("i", "n", false)
	end, 10) -- 10ms delay to ensure the window is ready
end, { noremap = true, silent = true, desc = "Open Copilot Chat and enter insert mode" })
----------------------------------
----------------------------------
----------------------------------
----------------------------------
----------------------------------
-- Define a global to hold the last image filename
vim.g.last_image_filename = vim.g.last_image_filename or "image.png"

vim.api.nvim_create_user_command("PasteImage", function()
	-- Use the last filename as the default
	local default = vim.g.last_image_filename
	local filename = vim.fn.input("Image filename: ", default)
	if filename == "" then
		print("❌ No filename provided.")
		return
	end

	-- Wrap the filename in quotes to handle spaces
	local cmd = 'xclip -selection clipboard -t image/png -o > "' .. filename .. '"'
	local result = vim.fn.system(cmd)

	-- Check if file is actually created and not empty
	local stat = vim.loop.fs_stat(filename)
	if stat and stat.size > 1 then
		-- Save this as the new default
		vim.g.last_image_filename = filename
		print("✅ Image saved as " .. filename)
	else
		print("❌ Failed to save image. Clipboard may not contain an image.")
	end
end, {})
----
----
----
----
--- split window
vim.keymap.set("n", "<leader>wo", function()
	-- Split the window vertically
	vim.cmd("vsplit")

	-- Optional: focus stays on original (left), move cursor back
	vim.cmd("wincmd h")
end, { noremap = true, silent = true, desc = "Vertical split (half screen)" })
------------------------------------
------------------------------------
------------------------------------
------------------------------------
local term_buf_id = nil
local term_win_id = nil

function ToggleBottomTerminal()
	-- determine "target" cwd: use current buffer's dir, else fallback to global cwd
	local bufn = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(bufn)
	local cwd = ""
	if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
		cwd = vim.fn.fnamemodify(bufname, ":p:h")
	else
		cwd = vim.fn.getcwd()
	end

	if term_win_id and vim.api.nvim_win_is_valid(term_win_id) then
		-- hide it if already visible
		vim.api.nvim_win_hide(term_win_id)
		term_win_id = nil
	else
		-- if the buffer exists, reuse it; otherwise create a new one
		if term_buf_id and vim.api.nvim_buf_is_valid(term_buf_id) then
			vim.cmd("botright new")
			vim.api.nvim_win_set_height(0, 10)
			vim.api.nvim_win_set_buf(0, term_buf_id)
		else
			vim.cmd("botright new")
			vim.api.nvim_win_set_height(0, 10)
			-- set local cwd of this window to the target dir, only if valid
			if cwd ~= "" and vim.fn.isdirectory(cwd) == 1 then
				vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
			end
			-- spawn a shell
			vim.cmd("term")
			term_buf_id = vim.api.nvim_get_current_buf()
		end

		-- remove any funky background highlights
		vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal,NormalNC:Normal")
		vim.cmd("startinsert")

		term_win_id = vim.api.nvim_get_current_win()
	end
end

-- map Alt-- to toggle
vim.api.nvim_set_keymap("n", "<A-->", [[:lua ToggleBottomTerminal()<CR>]], { noremap = true, silent = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name == "tsserver" then
			-- Next.js specific navigation
			vim.keymap.set("n", "gd", function()
				require("telescope.builtin").lsp_definitions({ jump_type = "never" })
			end, { buffer = args.buf, desc = "Goto Definition (TS)" })

			-- Component navigation
			vim.keymap.set(
				"n",
				"<leader>cc",
				"<cmd>Telescope find_files cwd=./components<CR>",
				{ desc = "Find Components" }
			)
			vim.keymap.set("n", "<leader>cp", "<cmd>Telescope find_files cwd=./pages<CR>", { desc = "Find Pages" })
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		vim.cmd("GoFmt")
	end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "Dockerfile", "*.dockerfile" },
	callback = function()
		vim.bo.filetype = "dockerfile"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.prisma",
	callback = function()
		vim.bo.filetype = "prisma"
	end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.prisma",
	callback = function()
		vim.bo.filetype = "graphql"
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.cmd([[highlight! clear CursorLine]])
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	-- NOTE: Plugins can also be added by using a table,
	-- with the first argument being the link and the following
	-- keys can be used to configure plugin behavior/loading/etc.
	{
		"ray-x/go.nvim",
		dependencies = { -- Optional dependencies
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("go").setup({
				gofmt = "gofumpt", -- Use 'gofumpt' for formatting
				max_line_len = 120,
				tag_transform = false,
				test_dir = "",
				comment_placeholder = "   ",
				lsp_cfg = true,
				lsp_on_attach = true,
				dap_debug = true,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				sqlls = {
					cmd = { "sql-language-server", "up", "--method", "stdio" },
					filetypes = { "sql" },
					root_dir = function()
						return vim.loop.cwd()
					end,
				},
				prisma = {
					cmd = { "prisma-language-server", "--stdio" },
					filetypes = { "prisma" },
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern("schema.prisma", ".git")(fname) or vim.fn.getcwd()
					end,
				},
			},
		},
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = "VeryLazy", -- lazy-load on BufReadPre or VeryLazy
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"andymass/vim-matchup",
		event = "VeryLazy",
	},
	{
		"ekalinin/Dockerfile.vim",
		ft = "dockerfile",
	},
	{
		"stephpy/vim-yaml",
		ft = "yaml",
	},
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = { "markdown" },
		config = function()
			vim.g.mkdp_auto_start = 0
		end,
	},
	{
		"elentok/format-on-save.nvim",
		config = function()
			require("format-on-save").setup({
				formatters = {
					{
						filename_pattern = { "*.tsx", "*.jsx", "*.ts", "*.js" },
						command = "eslint --fix --quiet",
						-- For projects with local ESLint installation:
						command = "./node_modules/.bin/eslint --fix --quiet $FILE_PATH",
					},
				},
				-- Optional: Enable format on save by default
				format_on_save = true,
			})
		end,
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main", -- 🔄 changed from 'canary' to 'main'
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			require("CopilotChat").setup({})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function()
			require("crates").setup({
				completion = {
					cmp = {
						enabled = true,
					},
				},
			})
			require("cmp").setup.buffer({
				sources = { { name = "crates" } },
			})
		end,
	},

	{
		"mattn/emmet-vim",
		ft = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
		init = function()
			-- Optional: Customize for Next.js JSX/TSX (e.g., className instead of class)
			vim.g.user_emmet_settings = {
				typescriptreact = {
					extends = "jsx",
					attributes = {
						["className"] = "class", -- Expand class to className
					},
				},
				javascriptreact = {
					extends = "jsx",
					attributes = {
						["className"] = "class",
					},
				},
			}
		end,
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup({
				global_settings = {
					enter_on_sendcmd = true,
					mark_branch = true,
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Define the custom Oil bar function
			CustomOilBar = function()
				local path = vim.fn.expand("%")
				path = path:gsub("oil://", "")
				return "  " .. vim.fn.fnamemodify(path, ":%")
			end

			-- Setup Oil with custom options
			require("oil").setup({
				keymaps = {
					["<C-h>"] = false,
					["<C-l>"] = false,
					["<C-k>"] = false,
					["<C-j>"] = false,
					["<M-h>"] = "actions.select_split",
					["<A-s>"] = function()
						vim.cmd("bd")
					end,
					["-"] = "actions.parent", -- Move up (go to parent directory)
					["-"] = function()
						vim.cmd("normal! k")
					end,
					-- Map '=' to move down (simulate pressing 'j')
					["="] = function()
						vim.cmd("normal! j")
					end,
				},
				win_options = {
					wrap = false,
					signcolumn = "no",
					winbar = "%{v:lua.CustomOilBar()}",
				},
				view_options = {
					show_hidden = true,
				},
				skip_confirm_for_simple_edits = true,
			})

			-- Keymap to toggle Oil with '_'
			vim.keymap.set("n", "<A-s>", "<CMD>Oil<CR>", { desc = "Toggle Oil" })
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"mbbill/undotree",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" } },
	},
	{
		"github/copilot.vim",
		dependencies = {},
		event = "VimEnter",
		config = function()
			vim.g.copilot_no_tab_map = false
			vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
		end,
	},
	----
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

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
				html = {},
				css = {},
				gopls = {
					settings = {
						gopls = {
							usePlaceholders = true,
							completeUnimported = true,
						},
					},
				},
				sqlls = {
					cmd = { "sql-language-server", "up", "--method", "stdio" },
					filetypes = { "sql" },
					root_dir = function()
						return vim.loop.cwd()
					end,
				},

				yamlls = {},
				dockerls = {},

				tsserver = {
					settings = {
						typescript = {
							preferences = {
								-- Enable Next.js-style path aliases (requires tsconfig.json "baseUrl" and "paths")
								importModuleSpecifierPreference = "project=relative",
							},
							-- Enable React Server Components typing (Next.js 13+)
							experimental = {
								enableProjectDiagnostics = true,
							},
						},
						javascript = {
							preferences = {
								importModuleSpecifierPreference = "project=relative",
							},
						},
					},
					-- Enable JSX/TSX support
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
									"className=\\s*[\"']([^\"']*)",
									"class:\\s*[\"']([^\"']*)",
									"([\\w-]+)=\\s*[\"']([^\"']*)", -- For styled-components-like syntax
								},
							},
						},
					},
				},

				prisma = {
					cmd = { "prisma-language-server", "--stdio" },
					filetypes = { "prisma" },
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern("schema.prisma", ".git")(fname) or vim.fn.getcwd()
					end,
				},
				omnisharp = {
					cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
					filetypes = { "cs", "csx", "vb" },
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git")(fname)
							or vim.fn.getcwd()
					end,
					settings = {
						FormattingOptions = {
							EnableEditorConfigSupport = true,
							OrganizeImports = true,
						},
						RoslynExtensionsOptions = {
							EnableAnalyzersSupport = true,
							EnableImportCompletion = true,
							EnableDecompilationSupport = true,
						},
						SdkIncludePrereleases = true,
					},
				},
			}
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"tsserver",
				"eslint",
				"prismals",
				"html-lsp", -- ✅ HTML support
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"typescript-language-server", -- ✅ Correct package name
					"eslint",
					"stylua",
					"html-lsp", -- ✅ HTML support
					"css-lsp", -- ✅ CSS support
					"prettier",
					"gopls",
					"gofumpt",
					"tailwindcss-language-server",
					"yaml-language-server",
					"sqlls",
					"prisma-language-server",
					"angular-language-server",
					"omnisharp", -- Ensures OmniSharp is installed
					--"dotnet-format", -- Optional: C# formatter
				},
			})

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local opts = {
							capabilities = capabilities,
						}

						if server_name == "tailwindcss" or server_name == "tailwindcss-language-server" then
							opts.settings = {
								tailwindCSS = {
									experimental = {
										classRegex = {
											"tw`([^`]*)",
											"className=\\s*[\"']([^\"']*)",
											"class:\\s*[\"']([^\"']*)",
											"([\\w-]+)=\\s*[\"']([^\"']*)", -- styled-components
										},
									},
								},
							}
							opts.filetypes = {
								"html",
								"css",
								"scss",
								"javascript",
								"javascriptreact",
								"typescript",
								"typescriptreact",
								"svelte",
								"vue",
							}
							opts.init_options = {
								userLanguages = {
									typescriptreact = "html",
									javascriptreact = "html",
								},
							}
						end
						if server_name == "yamlls" then
							opts.settings = {
								yaml = {
									schemas = {
										["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
									},
									validate = true,
									hover = true,
									completion = true,
								},
							}
						end
						if server_name == "dockerls" then
							opts.settings = {
								docker = {
									languageserver = {
										formatter = {
											ignoreMultilineInstructions = true, -- Optional: Ignore multiline instructions for formatting
										},
									},
								},
							}
							opts.filetypes = { "dockerfile" } -- Ensure dockerls attaches to Dockerfile filetype
						end
						if server_name == "angularls" then
							opts.filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" }
							opts.root_dir = require("lspconfig").util.root_pattern("angular.json", "project.json")
							opts.cmd = {
								"ngserver",
								"--stdio",
								"--tsProbeLocations",
								vim.fn.expand("$PWD/node_modules"),
								"--ngProbeLocations",
								vim.fn.expand("$PWD/node_modules"),
							}
						end
						if server_name == "omnisharp" then
							opts.cmd = servers.omnisharp.cmd
							opts.filetypes = servers.omnisharp.filetypes
							opts.root_dir = servers.omnisharp.root_dir
							opts.settings = servers.omnisharp.settings
						end

						require("lspconfig")[server_name].setup(opts)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang-format" }, -- Added clang-format for C files
				cpp = { "clang-format" }, -- Added clang-format for C++ files
				python = { "black" }, -- Added black for Python files
				sql = { "pg_format" },
				prisma = { "prisma-language-server" },
			},
			formatters = {
				pg_format = {
					prepend_args = {
						"--keyword-case",
						"upper",
						"--spaces",
						"2",
					},
				},
				prisma_language_server = {
					-- Optional: Add args if needed
					-- prepend_args = { "--format" },
				},
			},
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})
			local ls = luasnip
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node

			-- Add the snippet for multiple filetypes (optional)
			for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
				ls.add_snippets(ft, {
					s("cl", {
						t("console.log("),
						i(1),
						t(")"),
					}),
				})
			end
			ls.add_snippets("go", {
				s("echo", {
					t("fmt.Println("),
					i(1),
					t(")"),
				}),
				s("enl", {
					t("if err != nil {"),
					t({ "", "\t" }),
					i(1),
					t({ "", "}" }),
				}),
			})
			ls.add_snippets("html", {
				s("!", {
					t({ "<!DOCTYPE html>", '<html lang="en">', "<head>", '  <meta charset="UTF-8">' }),
					t({ "", '  <meta name="viewport" content="width=device-width, initial-scale=1.0">' }),
					t({ "", "  <title>" }),
					i(1, "Document"),
					t({ "</title>", "</head>" }),
					t({ "", "<body>", "" }),
					i(0),
					t({ "", "</body>", "</html>" }),
				}),
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<CR>"] = cmp.mapping.confirm({ select = true }),

					["<C-leader>"] = cmp.mapping.complete({}),

					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{
						name = "lazydev",
						group_index = 0,
					},
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "emoji" },
				},
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("tokyonight").setup({
				style = "moon",
				styles = {
					comments = { italic = false }, -- Disable italics in comments
					sidebars = "transparent", -- Keep sidebars darker
					floats = "dark", -- Make floating windows darker
				},
				terminal_colors = true, -- Ensure the terminal has matching colors
			})
			vim.cmd.colorscheme("tokyonight-night")
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
			vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = "NONE", background = "NONE" })
		end,
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })

			require("mini.surround").setup()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
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
}, {
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
