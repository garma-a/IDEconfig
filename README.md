# Modular Neovim & Terminal Configuration

This repository contains the complete developer configuration for **Neovim (v0.11+)**, **Kitty Terminal**, and **Zsh (Oh My Zsh + autocomplete + syntax highlighting + pixegami-agnoster theme)**.

## 🚀 Quick Setup on a New Machine (Ubuntu / Arch / Anarchy / Fedora)

To set up your complete terminal and editor experience from scratch on a new machine:

```bash
chmod +x setup.sh
./setup.sh
```

For detailed LLM agent instructions, supported distros, and manual steps, see [AGENTS.md](AGENTS.md).

## VSCode Integration

The `vscode.json` file contains VSCode keybindings that mirror the custom Neovim keymaps defined in `lua/config/keymaps.lua`. This allows the VSCode Vim extension to behave identically to the Neovim setup.

### How to use with VSCode

1. Install the [VSCode Vim extension](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim)
2. Copy the contents of `vscode.json` to your VSCode `keybindings.json` file:
   - On Windows/Linux: `File > Preferences > Keyboard Shortcuts` then click the "Open Keyboard Shortcuts (JSON)" icon
   - On macOS: `Code > Preferences > Keyboard Shortcuts` then click the "Open Keyboard Shortcuts (JSON)" icon
3. Save and reload VSCode

### Custom Keymaps Reference

The following custom keymaps from Neovim are now available in VSCode:

#### Basic Navigation & Editing
- `q` → `i` - Enter insert mode (remapped from `i`)
- `Q` → `I` - Insert at beginning of line (remapped from `I`)
- `m` → `q` - Start recording macro (remapped from `q`)
- `M` → `q` - Start recording macro (same as `m`)
- `w` → `b` - Move backward by word (remapped from `b`)
- `e` → `w` - Move forward by word (remapped from `w`)
- `b` → `m` - Set mark (remapped from `m`)

#### Indentation & Movement
- `+` → `=` - Auto-indent (remapped from `=`)
- `=` → `+` - Move down (remapped from `+`)
- `}` → `Ctrl+d` - Half page down (remapped from `Ctrl+d`)
- `{` → `Ctrl+u` - Half page up (remapped from `Ctrl+u`)
- `Ctrl+d` → `}` - Next paragraph (remapped from `}`)
- `Ctrl+e` → `{` - Previous paragraph (remapped from `{`)

#### Matching & End of Line
- `Ctrl+x` → `%` - Jump to matching bracket
- `Z` → `$` - Jump to end of line
- `ZZ` → Disabled (no save and quit in VSCode)

#### Window Navigation
- `Alt+Left` - Move to left window
- `Alt+Right` - Move to right window
- `Alt+Up` - Move to upper window
- `Alt+Down` - Move to lower window

#### Line Movement (Visual Mode)
- `Alt+j` - Move selected lines down
- `Alt+k` - Move selected lines up

#### Editor Navigation
- `<` - Previous editor tab
- `>` - Next editor tab
- `Ctrl+]` - Go to editor 1
- `Ctrl+[` - Go to editor 2
- `Ctrl+p` - Go to editor 3
- `Ctrl+o` - Go to editor 4

#### Problems/Diagnostics (Normal Mode)
- `Alt+j` - Next error/warning in location list
- `Alt+k` - Previous error/warning in location list
- `Alt+=` - Close current editor/buffer

#### Leader Key Mappings (Space as leader)
- `<leader>q` - Open problems/diagnostics panel
- `<leader>>` - Indent right (normal mode)
- `<leader>>` - Indent right and reselect (visual mode)
- `<leader><` - Indent left (normal mode)
- `<leader><` - Indent left and reselect (visual mode)
- `<leader>]` - Same as `Ctrl+]`
- `<leader>[` - Same as `Ctrl+[`
- `<leader>p` - Same as `Ctrl+p`
- `<leader>o` - Same as `Ctrl+o`

#### Escape Key Alternative
- `Alt+c` - Escape to normal mode (works in normal, insert, and visual modes)

### Note
Some Neovim keymaps related to plugins (Harpoon, Copilot Chat, Telescope, etc.) are not included in the VSCode configuration as they depend on Neovim-specific plugins. Only core vim keymaps and general editor navigation are included.

## Structure

```
├── init.lua                    # Main entry point (13 lines)
├── init_original.lua          # Backup of original monolithic file
└── lua/
    ├── config/                # Core configuration modules
    │   ├── globals.lua        # Global settings & leader keys
    │   ├── options.lua        # Vim options & settings
    │   ├── keymaps.lua        # Key mappings & custom functions
    │   ├── autocmds.lua       # Autocommands for filetypes
    │   └── lazy.lua           # Lazy.nvim plugin manager setup
    └── plugins/               # Plugin configurations
        ├── go.lua             # Go development tools
        ├── zig.lua            # Zig development tools
        ├── lsp.lua            # Language Server Protocol setup
        ├── misc.lua           # Utility plugins (colorizer, etc.)
        ├── treesitter.lua     # Syntax highlighting
        ├── telescope.lua      # Fuzzy finder
        ├── completion.lua     # Autocompletion & snippets
        ├── formatting.lua     # Code formatting
        ├── oil.lua            # File manager
        ├── copilot.lua        # AI assistance
        ├── git.lua            # Git integration
        └── ui.lua             # Themes & interface
```

## Benefits

- **Maintainable**: Each component is focused and easy to find
- **Modular**: Enable/disable features by adding/removing plugin files
- **Organized**: Clear separation between core config and plugins
- **Readable**: Much easier to navigate and understand
- **Same functionality**: All original features preserved exactly

## Supported Languages

This configuration includes full development support for:

- **Go**: LSP (gopls), formatting (gofumpt), debugging, testing
- **Zig**: LSP (zls), formatting (zig fmt), syntax highlighting, code snippets
- **TypeScript/JavaScript**: LSP (ts_ls), ESLint, Prettier formatting
- **HTML/CSS**: LSP, Tailwind CSS support, formatting
- **Python**: LSP, Black formatting
- **C/C++**: LSP, clang-format
- **C#**: LSP (OmniSharp), .NET support
- **SQL**: LSP (sqlls), pg_format
- **YAML/Docker**: LSP support
- **Prisma**: LSP for database schema
- **Lua**: LSP (lazydev), stylua formatting

## How it works

1. `init.lua` loads the core configuration modules in order:
   - `config.globals` - Sets up leader keys and global settings
   - `config.options` - Configures vim options
   - `config.keymaps` - Sets up all key mappings
   - `config.autocmds` - Configures autocommands
   - `config.lazy` - Bootstraps lazy.nvim and loads plugins

2. Lazy.nvim automatically loads all files in the `lua/plugins/` directory

## Customization

- To disable a plugin: Remove or rename the corresponding file in `lua/plugins/`
- To modify keymaps: Edit `lua/config/keymaps.lua`
- To change vim options: Edit `lua/config/options.lua`
- To add new plugins: Create a new file in `lua/plugins/`

## Migration

This modular structure maintains 100% compatibility with the original configuration.
The original 1351-line file has been preserved as `init_original.lua` for reference.