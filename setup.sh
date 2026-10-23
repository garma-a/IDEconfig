#!/usr/bin/env bash
# Run as the desktop user, without sudo. Only system commands use sudo.
set -Eeuo pipefail
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CODEX_WAS_INSTALLED=0
OPENCODE_WAS_INSTALLED=0
command -v codex >/dev/null && CODEX_WAS_INSTALLED=1
command -v opencode >/dev/null && OPENCODE_WAS_INSTALLED=1
export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$HOME/.local/share/IDEconfig/go/bin:$HOME/.dotnet:$HOME/.dotnet/tools:$HOME/go/bin:$PATH"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh" --no-use
  nvm use default >/dev/null 2>&1 || true
fi
[[ $# -le 1 ]] || { echo 'Use one option at a time.' >&2; exit 1; }
case "${1:-}" in
  --help|-h) cat "$REPO_DIR/docs/usage.txt"; exit 0 ;;
  --dry-run) cat "$REPO_DIR/docs/plan.txt"; python3 "$REPO_DIR/scripts/skills.py" --dry-run; exit 0 ;;
  --check) exec bash "$REPO_DIR/scripts/check.sh" ;;
  --skills-only) exec python3 "$REPO_DIR/scripts/skills.py" ;;
  --desktop-only) exec python3 "$REPO_DIR/scripts/desktop.py" ;;
  '') ;;
  *) printf 'Unknown option: %s\n' "$1" >&2; exit 1 ;;
esac
[[ $EUID -ne 0 ]] || { echo 'Run as your desktop user, without sudo.' >&2; exit 1; }
source /etc/os-release
[[ "$ID" == ubuntu ]] || { echo 'Full setup supports Ubuntu GNOME; see README.md.' >&2; exit 1; }
[[ "$(uname -m)" == x86_64 ]] || { echo 'Full setup needs amd64: Chrome for Linux has no ARM build. No packages changed.' >&2; exit 1; }
command -v sudo >/dev/null || { echo 'sudo is required.' >&2; exit 1; }
sudo -v
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/IDEconfig"
mkdir -p "$STATE_DIR"
LOG_FILE="$STATE_DIR/setup-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1
trap 'rc=$?; echo "FAILED at line $LINENO (exit $rc). Fix and rerun. Log: $LOG_FILE"; exit "$rc"' ERR
TASK_TMP="$(mktemp -d)"
trap 'rm -rf -- "$TASK_TMP"' EXIT
source "$REPO_DIR/scripts/common.sh"
sudo apt-get update
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git curl wget ca-certificates gnupg zsh kitty build-essential cmake pkg-config \
  ripgrep fd-find fzf xclip wl-clipboard unzip xz-utils tar fontconfig \
  python3 python3-venv python3-pip python3-gi jq xdg-utils dconf-cli libglib2.0-bin \
  clang-format postgresql-client sqlite3
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/IDEconfig"
link_file "$(command -v fdfind)" "$HOME/.local/bin/fd"
if ! dpkg-query -W -f='${Status}' google-chrome-stable 2>/dev/null | grep -q 'install ok installed'; then
  curl -fL --retry 3 https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o "$TASK_TMP/chrome.deb"
  chmod 644 "$TASK_TMP/chrome.deb"
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "$TASK_TMP/chrome.deb"
fi
if ! command -v nvim >/dev/null || ! nvim --clean --headless '+lua assert(vim.fn.has("nvim-0.12") == 1)' +qa >/dev/null 2>&1; then
  curl -fL --retry 3 https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-x86_64.tar.gz -o "$TASK_TMP/nvim.tar.gz"
  mkdir -p "$TASK_TMP/nvim"
  tar -xzf "$TASK_TMP/nvim.tar.gz" -C "$TASK_TMP/nvim" --strip-components=1
  replace_tree "$TASK_TMP/nvim" "$HOME/.local/share/IDEconfig/nvim"
  link_file "$HOME/.local/share/IDEconfig/nvim/bin/nvim" "$HOME/.local/bin/nvim"
fi
if ! command -v node >/dev/null || ! command -v npm >/dev/null || [[ "$(node -p 'Number(process.versions.node.split(".")[0])')" -lt 24 ]]; then
  if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    curl -fL --retry 3 https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o "$TASK_TMP/nvm.sh"
    PROFILE=/dev/null bash "$TASK_TMP/nvm.sh"
  fi
  source "$NVM_DIR/nvm.sh" --no-use
  nvm install 24
  nvm alias default 24
fi
# Preserve npm-installed clients when switching to a newer Node runtime.
if [[ $CODEX_WAS_INSTALLED -eq 1 ]] && ! command -v codex >/dev/null; then
  npm install --global --prefix "$HOME/.local" @openai/codex
fi
if [[ $OPENCODE_WAS_INSTALLED -eq 1 ]] && ! command -v opencode >/dev/null; then
  npm install --global --prefix "$HOME/.local" opencode-ai
fi
npm install --global --prefix "$HOME/.local" typescript@7.0.2 typescript-language-server dbml-lsp@0.1.0
# Kulala's locked HTTP grammar is generated locally by this CLI.
npm install --global --prefix "$HOME/.local" --allow-scripts=tree-sitter-cli tree-sitter-cli@0.27.1
python3 -m venv "$HOME/.neovim-venv"
"$HOME/.neovim-venv/bin/pip" install --disable-pip-version-check pynvim
if ! command -v go >/dev/null || [[ "$(go env GOVERSION)" != go1.26.* ]]; then
  curl -fL --retry 3 https://go.dev/dl/go1.26.0.linux-amd64.tar.gz -o "$TASK_TMP/go.tar.gz"
  tar -xzf "$TASK_TMP/go.tar.gz" -C "$TASK_TMP"
  replace_tree "$TASK_TMP/go" "$HOME/.local/share/IDEconfig/go"
fi
if ! command -v dotnet >/dev/null || ! dotnet --list-sdks | grep -q '^10\.'; then
  curl -fL --retry 3 https://dot.net/v1/dotnet-install.sh -o "$TASK_TMP/dotnet-install.sh"
  bash "$TASK_TMP/dotnet-install.sh" --channel 10.0 --install-dir "$HOME/.dotnet"
fi
if [[ -x "$HOME/.dotnet/dotnet" ]]; then export DOTNET_ROOT="$HOME/.dotnet"; fi
if ! command -v zig >/dev/null || [[ "$(zig version)" != 0.15.2 ]]; then
  curl -fL --retry 3 https://ziglang.org/download/0.15.2/zig-x86_64-linux-0.15.2.tar.xz -o "$TASK_TMP/zig.tar.xz"
  mkdir -p "$TASK_TMP/zig"
  tar -xJf "$TASK_TMP/zig.tar.xz" -C "$TASK_TMP/zig" --strip-components=1
  replace_tree "$TASK_TMP/zig" "$HOME/.local/share/IDEconfig/zig"
  link_file "$HOME/.local/share/IDEconfig/zig/zig" "$HOME/.local/bin/zig"
fi
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
if ! fc-match -f '%{family}' 'JetBrainsMono Nerd Font' | grep -q 'JetBrainsMono Nerd Font'; then
  mkdir -p "$FONT_DIR"
  curl -fL --retry 3 https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -o "$TASK_TMP/font.tar.xz"
  tar -xJf "$TASK_TMP/font.tar.xz" -C "$FONT_DIR"
  fc-cache -f "$FONT_DIR"
fi
clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
link_file "$REPO_DIR/pixegami-agnoster.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/pixegami-agnoster.zsh-theme"
link_file "$REPO_DIR/myzsh.zsh" "$HOME/.zshrc"
for item in 'myKittyConfig.conf:kitty.conf' 'current-theme.conf:current-theme.conf' 'cheatsheet.txt:cheatsheet.txt'; do
  link_file "$REPO_DIR/${item%%:*}" "$HOME/.config/kitty/${item#*:}"
done
if [[ "$(realpath -m "$HOME/.config/nvim")" != "$REPO_DIR" ]]; then link_file "$REPO_DIR" "$HOME/.config/nvim"; fi
for acc in a b; do
  if [[ -d "$HOME/.codex-$acc" && ! -e "$HOME/.codex-account-$acc" ]]; then
    ln -s ".codex-$acc" "$HOME/.codex-account-$acc"
  elif [[ -d "$HOME/.codex-account-$acc" && ! -e "$HOME/.codex-$acc" ]]; then
    ln -s ".codex-account-$acc" "$HOME/.codex-$acc"
  fi
done
sudo chsh -s "$(command -v zsh)" "$(id -un)"
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 60
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
python3 "$REPO_DIR/scripts/skills.py"
IDE_SETUP=1 IDE_SETUP_REPO="$REPO_DIR" nvim --headless -l "$REPO_DIR/scripts/bootstrap-nvim.lua"
desktop_pending=0
python3 "$REPO_DIR/scripts/desktop.py" || desktop_pending=$?
if [[ $desktop_pending -ne 0 && $desktop_pending -ne 2 ]]; then exit "$desktop_pending"; fi
if [[ $desktop_pending -eq 2 ]]; then echo 'Desktop pending: run bash setup.sh --desktop-only inside Ubuntu GNOME.'; fi
bash "$REPO_DIR/scripts/check.sh"
echo "Setup verified. Log: $LOG_FILE. Log out and back in to activate Zsh."
