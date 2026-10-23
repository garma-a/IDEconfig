#!/usr/bin/env bash
set -uo pipefail
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
export PATH="$HOME/.local/bin:$HOME/.local/share/IDEconfig/go/bin:$HOME/.dotnet:$HOME/.dotnet/tools:$HOME/go/bin:$PATH"
if [[ -x "$HOME/.dotnet/dotnet" ]]; then export DOTNET_ROOT="$HOME/.dotnet"; fi
failed=0
check() {
  if "$@"; then printf 'OK: %s\n' "$*"; else printf 'FAIL: %s\n' "$*" >&2; failed=1; fi
}
for tool in google-chrome kitty zsh nvim node npm go zig dotnet rg fd gcc make xclip wl-copy tree-sitter; do
  check command -v "$tool"
done
check test -f "$HOME/.config/kitty/kitty.conf"
check kitty +runpy 'import os; from kitty.config import load_config; problems=[]; load_config(os.path.expanduser("~/.config/kitty/kitty.conf"), accumulate_bad_lines=problems); assert not problems, repr(problems)'
check test -f "$HOME/.oh-my-zsh/custom/themes/pixegami-agnoster.zsh-theme"
check test -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
check test -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
check test "$(realpath -m "$HOME/.config/nvim")" = "$REPO_DIR"
check test "$(realpath -m "$HOME/.zshrc")" = "$REPO_DIR/myzsh.zsh"
check test "$(getent passwd "$(id -un)" | cut -d: -f7)" = "$(command -v zsh)"
check test "$(readlink -f /etc/alternatives/x-terminal-emulator)" = /usr/bin/kitty
check "$HOME/.neovim-venv/bin/python3" -c 'import pynvim'
check node -e 'if(Number(process.versions.node.split(".")[0]) < 24) process.exit(1)'
check bash -c 'fc-match -f "%{family}" "JetBrainsMono Nerd Font" | grep -q "JetBrainsMono Nerd Font"'
check zsh -ic '[[ "$ZSH_THEME" == pixegami-agnoster && -f "$ZSH/oh-my-zsh.sh" ]]'
check python3 "$REPO_DIR/scripts/skills.py" --check
check python3 "$REPO_DIR/scripts/desktop.py" --check
check env IDE_SETUP=1 IDE_VERIFY=1 IDE_SETUP_REPO="$REPO_DIR" nvim --headless -l "$REPO_DIR/scripts/verify-nvim.lua"
check env IDE_SETUP=1 IDE_VERIFY=1 IDE_SETUP_REPO="$REPO_DIR" nvim --headless -l "$REPO_DIR/scripts/verify-lsp.lua"
if [[ $failed -ne 0 ]]; then
  echo 'Setup is incomplete. Fix the listed failures, then rerun bash setup.sh.' >&2
  exit 1
fi
echo 'All required setup checks passed.'
