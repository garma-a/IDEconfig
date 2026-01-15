# Neovim to Zed Migration Guide

This guide will help you migrate from Neovim to the Zed text editor while maintaining a similar workflow and keybindings.

## Table of Contents

1. [Installing Zed](#installing-zed)
2. [Setting Up Configuration Files](#setting-up-configuration-files)
3. [Extensions to Install](#extensions-to-install)
4. [Keymap Reference](#keymap-reference)
5. [Feature Comparison](#feature-comparison)
6. [Learning Resources](#learning-resources)
7. [Tips for Transitioning](#tips-for-transitioning)

---

## Installing Zed

### Linux

```bash
# Using the official installer
curl -f https://zed.dev/install.sh | sh

# Or via Flatpak
flatpak install flathub dev.zed.Zed
```

### macOS

```bash
# Using Homebrew
brew install --cask zed

# Or download directly from zed.dev
```

### Windows

Zed for Windows is currently in development. Check [zed.dev](https://zed.dev) for the latest availability.

---

## Setting Up Configuration Files

Zed stores its configuration files in the following locations:

### Configuration Paths

| Platform | Settings Location | Keymap Location |
|----------|-------------------|-----------------|
| **Linux** | `~/.config/zed/settings.json` | `~/.config/zed/keymap.json` |
| **macOS** | `~/Library/Application Support/Zed/settings.json` | `~/Library/Application Support/Zed/keymap.json` |

### Quick Setup

1. **Copy the settings file:**
   ```bash
   # Linux
   cp zed/settings.json ~/.config/zed/settings.json
   
   # macOS
   cp zed/settings.json ~/Library/Application\ Support/Zed/settings.json
   ```

2. **Copy the keymap file:**
   ```bash
   # Linux
   cp zed/keymap.json ~/.config/zed/keymap.json
   
   # macOS
   cp zed/keymap.json ~/Library/Application\ Support/Zed/keymap.json
   ```

3. **Restart Zed** to apply the changes.

### Accessing Settings from Zed

You can also access settings directly from within Zed:

- **Open Settings:** `Cmd+,` (macOS) or `Ctrl+,` (Linux)
- **Open Keymap:** `Cmd+K Cmd+S` (macOS) or `Ctrl+K Ctrl+S` (Linux)
- **Command Palette:** `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Linux)

---

## Extensions to Install

Open the Extensions panel in Zed (`Cmd+Shift+X` on macOS, `Ctrl+Shift+X` on Linux) and install:

### Essential Extensions

| Extension | Description | Neovim Equivalent |
|-----------|-------------|-------------------|
| **Tokyonight** | Theme matching your Neovim setup | `folke/tokyonight.nvim` |
| **One Dark** | Alternative dark theme | N/A |
| **Catppuccin** | Popular dark theme | N/A |

### Language Support

| Extension | Description | Neovim Equivalent |
|-----------|-------------|-------------------|
| **Go** | Go language support | `ray-x/go.nvim` |
| **Rust** | Rust language support | Built-in LSP |
| **TypeScript** | TypeScript/JavaScript support | `tsserver` LSP |
| **Python** | Python language support | Built-in LSP |
| **C/C++** | C/C++ support | Built-in LSP |
| **Tailwind CSS** | Tailwind CSS intellisense | `tailwindcss` LSP |
| **Prisma** | Prisma schema support | `prisma-language-server` |
| **Docker** | Dockerfile support | `dockerls` |
| **YAML** | YAML language support | `yamlls` |
| **SQL** | SQL language support | `sqlls` |
| **HTML** | HTML support | `html-lsp` |

### Productivity Extensions

| Extension | Description | Neovim Equivalent |
|-----------|-------------|-------------------|
| **GitLens** | Enhanced Git integration | `lewis6991/gitsigns.nvim` |
| **Error Lens** | Inline error display | `vim.diagnostic` |
| **TODO Highlight** | Highlight TODOs | `folke/todo-comments.nvim` |
| **Rainbow Brackets** | Colorful bracket matching | `andymass/vim-matchup` |

### AI Extensions

| Extension | Description | Neovim Equivalent |
|-----------|-------------|-------------------|
| **Copilot** | GitHub Copilot integration (built-in) | `github/copilot.vim` |

> **Note:** Many features are built into Zed, including LSP support, so you may not need as many extensions as in Neovim.

---

## Keymap Reference

The custom keymaps from your Neovim configuration have been converted to Zed. Here's a reference:

### Basic Navigation & Editing

| Key | Action | Notes |
|-----|--------|-------|
| `q` | Enter insert mode | Remapped from `i` |
| `Q` | Insert at line start | Remapped from `I` |
| `m` | Start recording macro | Remapped from `q` |
| `;` | Set mark | Remapped from `m` |
| `w` | Move backward by word | Remapped from `b` |
| `e` | Move forward by word | Remapped from `w` |

### Indentation & Movement

| Key | Action | Notes |
|-----|--------|-------|
| `+` | Auto-indent/format | Remapped from `=` |
| `=` | Move down one line | Remapped from `+` |
| `}` | Half page down | Remapped from `Ctrl+d` |
| `{` | Half page up | Remapped from `Ctrl+u` |
| `Ctrl+d` | Next paragraph | Remapped from `}` |
| `Ctrl+e` | Previous paragraph | Remapped from `{` |

### Matching & End of Line

| Key | Action | Notes |
|-----|--------|-------|
| `Ctrl+x` | Jump to matching bracket | Remapped from `%` |
| `Z` | Jump to end of line | Remapped from `$` |

### Window Navigation

| Key | Action |
|-----|--------|
| `Alt+Left` | Focus left pane |
| `Alt+Right` | Focus right pane |
| `Alt+Up` | Focus upper pane |
| `Alt+Down` | Focus lower pane |

### Line Movement (Visual Mode)

| Key | Action |
|-----|--------|
| `Alt+j` | Move selection down |
| `Alt+k` | Move selection up |

### Diagnostics Navigation (Normal Mode)

| Key | Action |
|-----|--------|
| `Alt+j` | Go to next diagnostic |
| `Alt+k` | Go to previous diagnostic |
| `Alt+=` | Close current buffer |

### Tab Navigation

| Key | Action |
|-----|--------|
| `<` | Previous tab |
| `>` | Next tab |
| `Ctrl+]` | Go to tab 1 |
| `Ctrl+[` | Go to tab 2 |
| `Ctrl+p` | Go to tab 3 |
| `Ctrl+o` | Go to tab 4 |
| `Alt+1-5` | Quick tab switch |

### Leader Key Mappings (Space)

| Key | Action |
|-----|--------|
| `Space s f` | Find files (like Telescope) |
| `Space s g` | Search in project |
| `Space /` | Search in current buffer |
| `Space c a` | Code actions |
| `Space r n` | Rename symbol |
| `Space f` | Format buffer |
| `Space q` | Open diagnostics panel |
| `Space w o` | Split window vertically |
| `Space space` | Switch buffers |
| `g d` | Go to definition |
| `g r` | Find references |
| `Space t h` | Toggle inlay hints |

### AI/Copilot

| Key | Action |
|-----|--------|
| `Space c o` | Open AI assistant |
| `Space c f` | Ask AI to fix code (visual) |
| `Space c e` | Ask AI to explain code (visual) |

### Terminal & Sidebar

| Key | Action |
|-----|--------|
| `Alt+-` | Toggle terminal |
| `Alt+s` | Toggle sidebar |
| `Alt+a` | Toggle file explorer |
| `Alt+c` | Escape/exit mode |

---

## Feature Comparison

### What You Get in Zed

| Feature | Neovim | Zed |
|---------|--------|-----|
| Vim motions | ✅ Native | ✅ Built-in vim mode |
| LSP support | ✅ nvim-lspconfig | ✅ Built-in |
| File explorer | ✅ oil.nvim | ✅ Built-in project panel |
| Fuzzy finder | ✅ Telescope | ✅ Built-in file finder |
| Git integration | ✅ gitsigns.nvim | ✅ Built-in |
| Autocompletion | ✅ nvim-cmp | ✅ Built-in |
| Copilot | ✅ copilot.vim | ✅ Built-in |
| Multiple cursors | ✅ Limited | ✅ Full support |
| Collaboration | ❌ | ✅ Built-in real-time |
| Performance | ✅ Fast | ✅ Very fast (Rust) |
| Plugin ecosystem | ✅ Extensive | 🔄 Growing |

### What's Different

| Neovim Feature | Zed Equivalent |
|----------------|----------------|
| Harpoon | Use bookmarks (`Space h a`) or recent files |
| Telescope | Built-in file finder (`Space s f`) |
| Which-key | Command palette (`Ctrl+Shift+P`) |
| Treesitter | Built-in syntax highlighting |
| Mason | Built-in language server management |
| Lazy.nvim | Built-in extension manager |
| Oil.nvim | Built-in project panel + file operations |

---

## Learning Resources

### Official Documentation

- **Zed Documentation:** https://zed.dev/docs
- **Zed Keybindings Reference:** https://zed.dev/docs/key-bindings
- **Zed Settings Reference:** https://zed.dev/docs/configuring-zed

### Video Tutorials

- **YouTube:** Search for "Zed editor tutorial" or "Zed for vim users"
- **Zed's Official YouTube Channel:** https://www.youtube.com/@ZedIndustries

### Community Resources

- **Zed Discord:** https://discord.gg/zed
- **Zed GitHub:** https://github.com/zed-industries/zed
- **Reddit:** r/zed

### Learning Vim Mode in Zed

If you're already comfortable with Vim:
1. Zed's vim mode supports most standard Vim motions
2. Visual, Normal, and Insert modes work as expected
3. Ex commands are limited - use Command Palette instead
4. Macros work but with slight differences

---

## Tips for Transitioning

### Day 1-7: Getting Comfortable

1. **Start with the basics:** Open files, navigate, edit, save
2. **Use Command Palette:** `Ctrl+Shift+P` is your friend
3. **Learn the file finder:** `Ctrl+P` or `Space s f`
4. **Get used to the project panel:** `Alt+a` or click the sidebar

### Week 2: Building Muscle Memory

1. **Practice your custom keymaps:** The remapped keys should feel familiar
2. **Explore multi-cursor:** Select word, then `Cmd+D` / `Ctrl+D` for next occurrence
3. **Use splits:** `Space w o` for vertical split
4. **Learn diagnostics flow:** `Alt+j/k` for next/prev error

### Week 3-4: Power User Features

1. **Collaboration:** Try real-time collaboration with teammates
2. **AI features:** Use inline assist for code generation
3. **Project search:** `Cmd+Shift+F` for project-wide search
4. **Terminal integration:** `Alt+-` for quick terminal access

### Common Gotchas

1. **No Ex commands:** Use Command Palette instead of `:`
2. **Different plugin ecosystem:** Fewer extensions but more built-in features
3. **No init.lua:** Configuration is JSON-based
4. **Clipboard works differently:** System clipboard is automatic

### What to Keep in Mind

- Zed is actively developed - features are added regularly
- Some Neovim plugins have no equivalent yet
- The muscle memory will transfer for most Vim motions
- Performance is excellent - enjoy the speed!

---

## Folder Structure

This repository now contains configurations for three editors:

```
IDEconfig/
├── neovim/                  # Original Neovim configuration
│   ├── init.lua             # Main entry point
│   ├── init_original.lua    # Backup of monolithic config
│   ├── lazy-lock.json       # Plugin lock file
│   └── lua/
│       ├── config/          # Core configuration
│       └── plugins/         # Plugin configurations
├── vscode/                  # VSCode configuration
│   └── keybindings.json     # Custom keybindings
├── zed/                     # Zed configuration
│   ├── settings.json        # Editor settings
│   └── keymap.json          # Custom keybindings
├── README.md                # General documentation
└── MIGRATION.md             # This migration guide
```

---

## Quick Reference Card

Print this for your desk while learning:

```
╔══════════════════════════════════════════════════════════════╗
║                    ZED QUICK REFERENCE                       ║
╠══════════════════════════════════════════════════════════════╣
║  NAVIGATION                    │  EDITING                    ║
║  ──────────                    │  ───────                    ║
║  q    → Insert mode            │  Space f   → Format         ║
║  Q    → Insert at start        │  Space c a → Code actions   ║
║  w/e  → Back/Forward word      │  Space r n → Rename         ║
║  }/{  → Half page down/up      │  Alt+j/k   → Move line      ║
║  Z    → End of line            │  +         → Auto-indent    ║
║                                │                             ║
║  SEARCH & FILES                │  WINDOWS & TABS             ║
║  ─────────────                 │  ───────────────            ║
║  Space s f → Find files        │  Alt+←→↑↓  → Switch panes   ║
║  Space /   → Search buffer     │  </> → Prev/Next tab        ║
║  Space space → Switch buffers  │  Space w o → Split vertical ║
║  Alt+a     → File explorer     │  Alt+=     → Close buffer   ║
║                                │                             ║
║  TERMINAL & UI                 │  DIAGNOSTICS                ║
║  ─────────────                 │  ───────────                ║
║  Alt+-     → Toggle terminal   │  Alt+j/k → Next/Prev error  ║
║  Alt+s     → Toggle sidebar    │  Space q → Diagnostics      ║
║  Alt+c     → Escape            │  g d     → Go to definition ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Need Help?

1. **Command Palette:** `Ctrl+Shift+P` - Search for any command
2. **Keymap settings:** `Ctrl+K Ctrl+S` - See all keybindings
3. **Zed Discord:** Get help from the community
4. **This repository:** Check the config files for reference

Happy coding with Zed! 🚀
