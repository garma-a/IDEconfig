# My Ubuntu environment

Install Ubuntu, install and sign in to Codex, clone this repository, and ask Codex:

> Read AGENTS.md and set up this Ubuntu machine completely. Run the installer, fix any failures, and verify everything.

```bash
sudo apt-get update
sudo apt-get install -y git
mkdir -p ~/.config
git clone https://github.com/garma-a/IDEconfig.git ~/.config/nvim
cd ~/.config/nvim
codex
```

Use your normal GitHub access if the repository is private. The HTTPS clone needs no old machine's SSH host aliases. If ~/.config/nvim already exists, clone elsewhere; setup backs up and links the existing configuration. Keep the checkout after setup: installed configurations and skills link to it.

You can also run the setup yourself:

```bash
bash setup.sh
```

Run as your normal Ubuntu desktop user. sudo may ask for your password. Full setup targets **Ubuntu GNOME on Intel/AMD 64-bit hardware**, with internet access and sudo. Chrome's official Linux package does not support ARM; the installer stops before package changes on ARM. Other desktop environments and distributions need separate desktop/package handling.

## What gets restored

| Component | Result |
| --- | --- |
| Browser | Official Google Chrome, default for web links and HTML |
| Terminal | Kitty, default through Ubuntu alternatives and XDG terminal preferences |
| Shell | Zsh login shell, Oh My Zsh, pixegami-agnoster, autosuggestions and syntax highlighting |
| Font | JetBrains Mono Nerd Font, selected in Kitty |
| Editor | Modern Neovim, the existing settings and keymaps, plugins from lazy-lock.json |
| Language tools | Node 24, Go 1.26, .NET 10, stable Zig; Mason LSPs, formatters and debuggers; Treesitter parsers |
| AI skills | 38 bundled custom skills with supporting files, checksums and available source links |
| Desktop | Workspace and window shortcuts captured from the source machine, Caps Lock as Ctrl, Ctrl+Alt+T for Kitty |

The setup uses **four fixed workspaces**. The Windows key is called Super in GNOME:

| Shortcut | Destination |
| --- | --- |
| Win + backtick (`) | Workspace 1 |
| Win + 1 | Workspace 2 |
| Win + 2 | Workspace 3 |
| Win + 3 | Workspace 4 |
| Ctrl + Alt + T | Kitty |

This matches the inspected machine's numbered bindings. Ubuntu's conflicting application/dock shortcuts are cleared. Other captured window-navigation shortcuts are stored in desktop/gnome.json. Caps Lock no longer changes its meaning each time a shell opens.

## Skills

[Browse every bundled skill and its source](ai/README.md), plus [provider-managed skills and plugin links](ai/PROVIDED-SKILLS.md). Bundles preserve local customizations, so setup does not depend on upstream repositories remaining available.

Skills are installed only for clients already present:

| Client | Global destination |
| --- | --- |
| Codex, including separate account profiles | ~/.agents/skills |
| Antigravity CLI (`agy`) | ~/.gemini/antigravity-cli/skills |
| OpenCode | ~/.config/opencode/skills |

After installing another client, run `bash setup.sh --skills-only` and restart the client. Codex-provided system skills come with Codex. Connector-backed plugins require their plugin installation and account connections; those cannot be restored by copying skill text.

## Verification and recovery

```bash
bash setup.sh --dry-run       # no changes
bash setup.sh --check         # nonzero exit if anything required is incomplete
bash setup.sh --skills-only   # restore skills for installed clients
bash setup.sh --desktop-only  # run inside the Ubuntu GNOME desktop
```

Conflicting dotfiles are renamed to adjacent *.backup.* paths. Skill backups go into a sibling skill-backups/ directory, outside client discovery paths. Previous changed GNOME values and setup logs go to ~/.local/state/IDEconfig/. Rerun after fixing a failed download or installation; required failures are not hidden.

Log out and back in once after setup to activate the Zsh login shell. Sign in to Chrome for your browser sync and authorize Copilot/Supermaven if you use them. Passwords, SSH keys, browser sessions, project files and account credentials are separate from this repository.

[Setup details, recovery and sources](docs/SETUP.md). Before switching devices, commit and push the updated repository so the next clone includes this setup and skill snapshot.
