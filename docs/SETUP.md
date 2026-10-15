# Setup details

## Scope and first run

The full installer targets Ubuntu GNOME amd64. Ubuntu 24.04 and newer are the intended baseline. The isolated integration image uses Ubuntu 24.04; a container verifies software/configuration but cannot prove GPU rendering or physical keyboard behavior under Wayland.

The user's initial steps are Ubuntu installation, network connection, Codex installation/sign-in and Git clone. After that, ask Codex to read AGENTS.md and finish setup. Run from the desktop session so GNOME defaults can be applied. sudo passwords and browser/provider sign-ins require the human.

The checkout may live anywhere. Setup links ~/.config/nvim, ~/.zshrc, Kitty configuration and skills to it. Keep the checkout in place. Back up or use another clone destination when ~/.config/nvim is already occupied.

## Repeatability

Neovim uses the checked-in plugin lockfile and a compatible official release (0.11.6 when an upgrade is needed). Node 24, Go 1.26.0, Zig 0.15.2 and ZLS 0.15.0 are deliberate runtime baselines. TypeScript 7.0.2 provides the configured native `tsc --lsp --stdio` command; DBML LSP is 0.1.0. .NET uses the latest servicing release in channel 10.0. Other Mason packages, fonts, Chrome and apt packages receive their upstream versions at install time. This is a repeatable configuration, not a bit-for-bit OS image.

Skills use SHA-256-checked local snapshots. Source links identify origins where recorded; unknown local origins are explicitly labelled. scripts/capture-skills.py updates snapshots from known skill directories only, and refuses conflicting same-name variants or external symlinks. It does not export account configuration. The Playwright skill also receives compatibility links under the default and existing Codex profile skill directories because its helper command uses CODEX_HOME/skills/playwright. Review the diff before committing a refresh.

The installer waits for plugin operations, Mason packages and configured parsers. Verification also opens temporary source files and confirms representative language servers attach. It then checks the installed plugins against lazy-lock.json and verifies enabled LSPs. The normal editor retains its keymaps; Space is the leader. Read lua/config/keymaps.lua and plugin keymaps for exact bindings.

## Desktop defaults

The captured bindings are in desktop/gnome.json. Four fixed workspaces intentionally replace the source machine's dynamic-workspace setting, ensuring all four numbered destinations exist on an empty new desktop.

Kitty defaults cover update-alternatives, the older GNOME terminal shortcut, and the newer Ubuntu XDG terminal preference lists. A deterministic Ctrl+Alt+T custom shortcut is installed while preserving other custom-shortcut entries. Workspace keys take precedence over Ubuntu's app-launch keys. The setup applies Caps Lock as Ctrl through GNOME, covering X11 and Wayland.

The desktop helper refuses to apply changes outside a GNOME user session. From SSH, software setup can finish but --check reports pending desktop configuration. Log into GNOME and run `bash setup.sh --desktop-only`, then `bash setup.sh --check`.

## Recovery

- Required failures stop the installer with the failing line and log path. Fix the reported cause and rerun.
- Logs and old GNOME values: ~/.local/state/IDEconfig/.
- Replaced dotfiles have adjacent *.backup.* names; replaced skills go under the skill directory's sibling skill-backups/ folder. To restore one, remove the installed symlink and move the selected backup to its old name.
- To restore selected desktop values, read a desktop-before-*.json backup and run `gsettings set SCHEMA KEY VALUE` for each entry. Use the stored GVariant value as one quoted argument.
- If client skills are not immediately visible, restart the client. Run --skills-only again after installing agy or OpenCode.
- If an upstream download disappears, update its version/URL in setup.sh and rerun the isolated integration test before claiming setup works.
- Package installation and login-shell changes are not automatically undone by restoring dotfiles.

## User-only tasks

Chrome sync, Codex/provider authentication, Copilot authorization, Supermaven authorization and private repository access depend on the user's accounts. Fresh-machine setup does not copy credentials. Codex aliases for account-a/account-b are convenience launchers; sign in to each profile separately if desired. Connectors and MCP servers need their own client installation and authentication.

This repository covers the requested desktop/developer environment. Applications referenced only by optional personal aliases (for example SimulIDE, Proteus/Wine or a private grit checkout) are not installed. Project dependencies, containers, databases and personal files are restored separately.

## Official sources checked during implementation

- [Codex skill discovery](https://learn.chatgpt.com/docs/build-skills): shared ~/.agents/skills and symlink support.
- [Antigravity skill locations](https://www.antigravity.google/docs/skills): CLI skills under ~/.gemini/antigravity-cli/skills.
- [OpenCode skill discovery](https://opencode.ai/docs/skills): global ~/.config/opencode/skills.
- [Ubuntu default terminal](https://ubuntu.com/desktop/docs/en/latest/how-to/change-the-default-terminal/): Ubuntu 25.04+ uses ubuntu-xdg-terminals.list.
- [Official Neovim release](https://github.com/neovim/neovim/releases/tag/v0.11.6).
- [Mason headless installation](https://github.com/mason-org/mason.nvim/blob/main/doc/mason.txt).
- [Zig downloads](https://ziglang.org/download/) and [Go downloads](https://go.dev/dl/).

## Reproduce the isolated Ubuntu test

```bash
docker build -f tests/ubuntu.Dockerfile -t ideconfig-setup-test .
docker run --rm ideconfig-setup-test
```

The test creates a separate user/home and private D-Bus session. It performs actual package installation inside the container. Host packages and desktop settings are unaffected. GPU rendering and physical keyboard shortcuts still need a desktop login check.
