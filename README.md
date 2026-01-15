# IDE Configuration Repository

A comprehensive collection of editor configurations for Neovim, VSCode, and Zed with consistent keybindings and settings across all editors.

## 🚀 January 2026 Update: Zed Migration

This repository now includes Zed configuration as the primary editor setup. See [MIGRATION.md](./MIGRATION.md) for a complete migration guide from Neovim to Zed.

## Repository Structure

```
IDEconfig/
├── neovim/                  # Neovim configuration
│   ├── init.lua             # Main entry point
│   ├── init_original.lua    # Backup of monolithic config
│   ├── lazy-lock.json       # Plugin lock file
│   └── lua/
│       ├── config/          # Core configuration modules
│       │   ├── globals.lua  # Global settings & leader keys
│       │   ├── options.lua  # Vim options & settings
│       │   ├── keymaps.lua  # Key mappings
│       │   ├── autocmds.lua # Autocommands
│       │   └── lazy.lua     # Plugin manager setup
│       └── plugins/         # Plugin configurations
├── vscode/                  # VSCode configuration
│   └── keybindings.json     # Custom keybindings for VSCode Vim
├── zed/                     # Zed configuration (NEW!)
│   ├── settings.json        # Editor settings
│   └── keymap.json          # Custom keybindings
├── README.md                # This file
└── MIGRATION.md             # Neovim to Zed migration guide
```

---

## Zed Setup (Recommended - 2026)

### Quick Start

1. **Install Zed:**
   ```bash
   curl -f https://zed.dev/install.sh | sh
   ```

2. **Copy configuration:**
   ```bash
   # Linux
   cp zed/settings.json ~/.config/zed/settings.json
   cp zed/keymap.json ~/.config/zed/keymap.json
   
   # macOS
   cp zed/settings.json ~/Library/Application\ Support/Zed/settings.json
   cp zed/keymap.json ~/Library/Application\ Support/Zed/keymap.json
   ```

3. **Restart Zed**

See [MIGRATION.md](./MIGRATION.md) for detailed setup instructions and learning resources.

---

## VSCode Setup

### How to use with VSCode

1. Install the [VSCode Vim extension](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim)
2. Copy the contents of `vscode/keybindings.json` to your VSCode `keybindings.json` file:
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

---

## Neovim Setup (Legacy)

### How to use

1. **Symlink or copy the neovim folder:**
   ```bash
   # Linux/macOS
   ln -s $(pwd)/neovim ~/.config/nvim
   
   # Or copy
   cp -r neovim/* ~/.config/nvim/
   ```

2. **Open Neovim** - Lazy.nvim will automatically install plugins

### Neovim Structure

```
neovim/
├── init.lua                    # Main entry point
├── init_original.lua           # Backup of original monolithic config
├── lazy-lock.json              # Plugin version lock file
└── lua/
    ├── config/                 # Core configuration modules
    │   ├── globals.lua         # Global settings & leader keys
    │   ├── options.lua         # Vim options & settings
    │   ├── keymaps.lua         # Key mappings & custom functions
    │   ├── autocmds.lua        # Autocommands for filetypes
    │   └── lazy.lua            # Lazy.nvim plugin manager setup
    └── plugins/                # Plugin configurations
        ├── go.lua              # Go development tools
        ├── zig.lua             # Zig development tools
        ├── lsp.lua             # Language Server Protocol setup
        ├── misc.lua            # Utility plugins (colorizer, etc.)
        ├── treesitter.lua      # Syntax highlighting
        ├── telescope.lua       # Fuzzy finder
        ├── completion.lua      # Autocompletion & snippets
        ├── formatting.lua      # Code formatting
        ├── oil.lua             # File manager
        ├── copilot.lua         # AI assistance
        ├── git.lua             # Git integration
        └── ui.lua              # Themes & interface
```

### Supported Languages

Full development support for:

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

---

## Customization

### For Zed
- Edit `zed/settings.json` for editor settings
- Edit `zed/keymap.json` for keybindings

### For VSCode
- Edit `vscode/keybindings.json` for custom keybindings

### For Neovim
- To disable a plugin: Remove or rename the corresponding file in `neovim/lua/plugins/`
- To modify keymaps: Edit `neovim/lua/config/keymaps.lua`
- To change vim options: Edit `neovim/lua/config/options.lua`
- To add new plugins: Create a new file in `neovim/lua/plugins/`

---

## License

Feel free to use and modify these configurations for your own setup.