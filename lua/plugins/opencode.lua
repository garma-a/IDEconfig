return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		-- Recommended for `ask()` and `select()`.
		-- Required for `snacks` provider.
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			events = {
				reload = true,
			},
			-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
			provider = {
				cmd = "env OPENCODE_DISABLE_FILETIME_CHECK=true opencode --port",
				terminal = {
					width = math.floor(vim.o.columns * 0.5),
				},
				snacks = {
					win = {
						width = 0.5,
					},
				},
			},
			prompts = {
				-- Command Name: "EditStrict"
				SingleFile = {
					-- This text will be sent to the LLM
					prompt = [[
# SYSTEM INSTRUCTION: Single File Edit & Diff Mode
You are a precise code editing assistant. You must adhere to the following strict rules:

1. **Scope Restriction:** You are authorized to edit **ONLY ONE** file per response. Focus strictly on the primary file provided in the context.
2. **Output Format:** Do not output the full file. Present changes using **Unified Diff** format:
   - Show context around changes.
   - Mark removed lines with `-`.
   - Mark added lines with `+`.

Task:
{{input}}
          ]],
					-- If the plugin supports defining where to direct the output or specific model params:
					description = "Edit single file with strict Diff output",
				},
			},
			Inline = {
				description = "Force blind write inline editing",
				prompt = [[
# SYSTEM INSTRUCTIONS: INLINE FILE EDITING

You are a precise code editing agent. You must adhere to the following execution protocols strictly.

## PROTOCOL 1: BLIND WRITE (CRITICAL)
- **Do not re-read the file.** Assume the current buffer state is final.
- **Force Overwrite:** Even if the file has changed externally since your last read, do not attempt to merge or validate. Output the new content for the target lines immediately.

## PROTOCOL 2: EXPLICIT RANGES
If the user provides specific line ranges (e.g., "lines 1-4"):
1. **Strict Entry/Exit Points:** You are FORBIDDEN from modifying code *before* the start line or *after* the end line of the requested range.
2. **Vertical Expansion Allowed:** The range defines the *anchor* of the edit, not the *volume*.
   - *Example:* If asked to replace lines 1-4, you must overwrite that specific block. However, if the clean solution requires 30 lines of code, **you may output 30 lines**.
   - **Rule:** You can insert and expand code freely, as long as the insertion happens strictly between the start and end markers you are replacing.
3. **Disjoint Ranges:** If multiple ranges are given, apply this logic to each block independently.

## PROTOCOL 3: NO RANGES SPECIFIED
If no line ranges are provided:
1. **Target:** Edit the currently open buffer/file.
2. **Minimize Edit Locations:** Apply changes in the fewest number of contiguous blocks possible (ideally 1 or 2 places).
3. **Structural Integrity:** Do not refactor the entire file just to create a single edit location. Modify the existing structure where it stands, but group your logic tightly to avoid scattering edits across the file.

Task:
{{input}}
          ]],
			},
		}

		-- Required for `opts.events.reload`.
		vim.o.autoread = true

		-- Recommended/example keymaps.
		vim.keymap.set({ "n", "x" }, "<A-a>", function()
			require("opencode").ask("/inline @this : ", { submit = true })
		end, { desc = "Ask opencode…" })
		vim.keymap.set({ "n", "x" }, "<A-e>", function()
			require("opencode").select()
		end, { desc = "Execute opencode action…" })
		vim.keymap.set({ "n", "t" }, "<A-v>", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode" })

		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })
		vim.keymap.set("n", "goo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })

		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })
		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })

		-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
		-- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
		-- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
	end,
}
