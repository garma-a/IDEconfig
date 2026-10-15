# Fresh Ubuntu setup

This repository restores Girgis's desktop and development environment. When the user asks to set up a new machine, complete the setup and verification in the same task.

1. Read README.md for requirements and expected results.
2. Run `bash setup.sh --dry-run` from this checkout.
3. Run `bash setup.sh` as the logged-in desktop user. Use the environment's approval mechanism for sudo/network access. Never run the whole script as root.
4. Fix failures and rerun; existing conflicting files are backed up automatically.
5. Run `bash setup.sh --check`. Completion requires exit 0. Report any failed/pending item explicitly.

The target is Ubuntu GNOME on amd64 with internet and sudo. Run desktop configuration in the user's GNOME session. If operating over SSH, finish everything else, then run `bash setup.sh --desktop-only` after desktop login. A missing desktop session is pending, not success.

The desired workspace mapping is the source machine's exact mapping: Super+grave -> workspace 1, Super+1 -> 2, Super+2 -> 3, Super+3 -> 4. Use four fixed workspaces so every shortcut has a destination. The authoritative settings are in desktop/gnome.json.

Install the bundled skills for clients already present; leave absent AI clients skipped. Codex's shared user directory supports separate CODEX_HOME profiles. Re-run `bash setup.sh --skills-only` after adding clients, then restart them.

For maintenance:
- The skill inventory, original links and SHA-256 checksums are in ai/README.md and ai/skills-manifest.json. Refresh only when asked using scripts/capture-skills.py, then review the diff. Keep complete supporting files.
- Neovim tool requirements live in lua/config/tools.lua; parser requirements live in lua/plugins/treesitter.lua; plugin versions live in lazy-lock.json. Restore locked versions during setup.
- Run `python3 -m unittest discover -s tests -v`, `bash -n setup.sh scripts/common.sh scripts/check.sh`, and `zsh -n myzsh.zsh` after installer changes. tests/ubuntu.Dockerfile runs the actual installer in an isolated Ubuntu container.
- Read docs/SETUP.md for recovery, account-only tasks and source links.
- Keep authentication and machine secrets outside Git. Preserve existing user files in backups.
