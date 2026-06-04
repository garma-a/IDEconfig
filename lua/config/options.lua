-- Core Neovim options
-- See `:help option-list` for documentation on each option

------------------------------------------------------------------------
-- Line numbers
------------------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true

------------------------------------------------------------------------
-- Mouse & cursor
------------------------------------------------------------------------
vim.opt.mouse = "a"
vim.opt.guicursor = "n-v-c:block,i:block"

------------------------------------------------------------------------
-- UI
------------------------------------------------------------------------
vim.opt.showmode = false     -- Mode shown in statusline (mini.statusline) instead
vim.opt.signcolumn = "yes"   -- Always show sign column (no layout shift)
vim.opt.cursorline = true    -- Highlight current line
vim.opt.wrap = false         -- No line wrapping (better for wide code)
vim.opt.scrolloff = 10       -- Keep 10 lines above/below cursor
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

------------------------------------------------------------------------
-- Clipboard
------------------------------------------------------------------------
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
end)

------------------------------------------------------------------------
-- Search
------------------------------------------------------------------------
vim.opt.ignorecase = true    -- Case-insensitive search...
vim.opt.smartcase = true     -- ...unless uppercase is used
vim.opt.inccommand = "split" -- Live preview of :substitute

------------------------------------------------------------------------
-- Indentation
------------------------------------------------------------------------
vim.opt.breakindent = true   -- Wrapped lines keep their indent

------------------------------------------------------------------------
-- Files & history
------------------------------------------------------------------------
vim.opt.undofile = true       -- Persistent undo across sessions
vim.opt.undolevels = 10000    -- Deep undo history
vim.opt.swapfile = false      -- No swap files (undofile is enough)
vim.opt.confirm = true        -- Confirm before closing unsaved buffers

------------------------------------------------------------------------
-- Timing
------------------------------------------------------------------------
vim.opt.updatetime = 250      -- Faster CursorHold events (used by LSP highlights)
vim.opt.timeoutlen = 300      -- Key sequence timeout in ms (was 50 — too aggressive)

------------------------------------------------------------------------
-- Splits
------------------------------------------------------------------------
vim.opt.splitright = true     -- Vertical splits open to the right
vim.opt.splitbelow = true     -- Horizontal splits open below

------------------------------------------------------------------------
-- Performance
------------------------------------------------------------------------
vim.opt.redrawtime = 1500     -- Raise threshold before "slow syntax" warning
vim.opt.synmaxcol = 300       -- Don't highlight beyond column 300 (perf on wide files)

------------------------------------------------------------------------
-- Shell
------------------------------------------------------------------------
vim.opt.shell = "zsh"         -- Use zsh for :term and system() calls