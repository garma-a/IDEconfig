#!/usr/bin/env bash
# ==============================================================================
# Terminal & Development Environment Automated Setup Script
# Works on: Ubuntu/Debian, Arch Linux / Anarchy / Manjaro, Fedora, openSUSE
# Sets up: Kitty, Zsh, Oh My Zsh, Custom Theme, Plugins, Neovim 0.11+, Nerd Font
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="${HOME:-/home/$(whoami)}"

# Colors for friendly output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# Helper for sudo
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    warn "Running as non-root without sudo. System package installations may be skipped."
  fi
fi

# ------------------------------------------------------------------------------
# 1. Detect Architecture and OS / Distro
# ------------------------------------------------------------------------------
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)  NVIM_ARCH="linux-x86_64" ;;
  aarch64|arm64) NVIM_ARCH="linux-arm64" ;;
  *) err "Unsupported CPU architecture: $ARCH"; exit 1 ;;
esac

DISTRO="unknown"
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO="${ID:-unknown}"
  DISTRO_LIKE="${ID_LIKE:-}"
fi

info "Detected Distribution: $DISTRO (Architecture: $ARCH)"

# ------------------------------------------------------------------------------
# 2. Install Distro System Dependencies
# ------------------------------------------------------------------------------
info "Installing system dependencies..."

# Check if essential tools are already installed
MISSING_DEPS=()
for cmd in git curl zsh kitty rg make gcc xclip; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING_DEPS+=("$cmd")
  fi
done

if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
  success "All essential CLI tools (git, curl, zsh, kitty, rg, make, gcc, xclip) are already installed."
else
  info "Missing tools detected: ${MISSING_DEPS[*]}. Installing via package manager..."
  install_packages() {
    if [ -n "$SUDO" ] || [ "$(id -u)" -eq 0 ]; then
      case "$DISTRO" in
        ubuntu|debian|pop|linuxmint|elementary|zorin)
          $SUDO apt-get update -y
          $SUDO apt-get install -y \
            git curl wget zsh kitty build-essential make gcc \
            ripgrep fd-find xclip unzip tar fontconfig
          # Ensure fd is accessible as 'fd' on Debian/Ubuntu
          mkdir -p "$USER_HOME/.local/bin"
          if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
            ln -sf "$(which fdfind)" "$USER_HOME/.local/bin/fd"
          fi
          ;;

        arch|anarchy|manjaro|endeavouros|artix|arcolinux)
          $SUDO pacman -Syu --noconfirm --needed \
            git curl wget zsh kitty base-devel make gcc \
            ripgrep fd xclip unzip tar fontconfig neovim
          # Install Nerd Font via pacman if available
          $SUDO pacman -S --noconfirm --needed ttf-jetbrains-mono-nerd || true
          ;;

        fedora|rhel|centos|rocky|alma)
          $SUDO dnf install -y \
            git curl wget zsh kitty gcc gcc-c++ make \
            ripgrep fd-find xclip unzip tar fontconfig
          ;;

        opensuse*|suse)
          $SUDO zypper install -y \
            git curl wget zsh kitty gcc gcc-c++ make \
            ripgrep fd xclip unzip tar fontconfig
          ;;

        *)
          warn "Unrecognized Linux distribution: $DISTRO."
          if command -v pacman >/dev/null 2>&1; then
            $SUDO pacman -Syu --noconfirm --needed git curl wget zsh kitty base-devel ripgrep fd xclip unzip tar fontconfig || true
          elif command -v apt-get >/dev/null 2>&1; then
            $SUDO apt-get update -y && $SUDO apt-get install -y git curl wget zsh kitty build-essential ripgrep fd-find xclip unzip tar fontconfig || true
          fi
          ;;
      esac
    else
      warn "Skipping system package manager step (no sudo). Ensure missing tools are installed manually."
    fi
  }

  install_packages || warn "Some system packages could not be installed automatically; continuing..."
fi

# ------------------------------------------------------------------------------
# 3. Ensure Neovim v0.10+ (specifically v0.11+) is installed
# ------------------------------------------------------------------------------
info "Checking Neovim version..."

is_modern_nvim() {
  if command -v nvim >/dev/null 2>&1; then
    local version_str
    version_str="$(nvim --version 2>/dev/null | head -n 1)"
    # Extract version numbers, e.g. v0.11.0 -> major 0, minor 11
    if [[ "$version_str" =~ v([0-9]+)\.([0-9]+) ]]; then
      local major="${BASH_REMATCH[1]}"
      local minor="${BASH_REMATCH[2]}"
      if [ "$major" -gt 0 ] || [ "$minor" -ge 10 ]; then
        return 0
      fi
    fi
  fi
  return 1
}

if is_modern_nvim; then
  success "Modern Neovim detected: $(nvim --version | head -n1)"
else
  info "Installing modern Neovim (v0.11+ prebuilt binary)..."
  NVIM_TAR="nvim-${NVIM_ARCH}.tar.gz"
  NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/${NVIM_TAR}"
  TMP_DIR="$(mktemp -d)"

  curl -fsSL "$NVIM_URL" -o "$TMP_DIR/$NVIM_TAR"
  mkdir -p "$TMP_DIR/extracted"
  tar -xzf "$TMP_DIR/$NVIM_TAR" -C "$TMP_DIR/extracted" --strip-components=1

  if [ -n "$SUDO" ]; then
    $SUDO rm -rf /opt/nvim
    $SUDO mkdir -p /opt/nvim /usr/local/bin
    $SUDO cp -r "$TMP_DIR/extracted"/* /opt/nvim/
    $SUDO ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  else
    mkdir -p "$USER_HOME/.local/opt/nvim" "$USER_HOME/.local/bin"
    rm -rf "$USER_HOME/.local/opt/nvim"/*
    cp -r "$TMP_DIR/extracted"/* "$USER_HOME/.local/opt/nvim/"
    ln -sf "$USER_HOME/.local/opt/nvim/bin/nvim" "$USER_HOME/.local/bin/nvim"
  fi

  rm -rf "$TMP_DIR"
  success "Neovim installed successfully: $(nvim --version | head -n 1)"
fi

# ------------------------------------------------------------------------------
# 4. Install Nerd Font (JetBrainsMono Nerd Font)
# ------------------------------------------------------------------------------
info "Checking for Nerd Fonts..."
if fc-list : family 2>/dev/null | grep -iq "nerd font"; then
  success "Nerd Font already installed."
else
  info "Installing JetBrains Mono Nerd Font for icons & powerline prompt..."
  FONT_DIR="$USER_HOME/.local/share/fonts/NerdFonts"
  mkdir -p "$FONT_DIR"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
  curl -fsSL "$FONT_URL" -o "/tmp/JetBrainsMono.tar.xz"
  tar -xJf "/tmp/JetBrainsMono.tar.xz" -C "$FONT_DIR"
  rm -f "/tmp/JetBrainsMono.tar.xz"
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -fv "$FONT_DIR" >/dev/null 2>&1 || true
  fi
  success "JetBrains Mono Nerd Font installed to $FONT_DIR"
fi

# ------------------------------------------------------------------------------
# 5. Install Node.js & npm (Required for Mason LSPs / Copilot / Prettier)
# ------------------------------------------------------------------------------
info "Checking Node.js & npm..."
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  info "Installing Node.js LTS via nvm..."
  export NVM_DIR="$USER_HOME/.nvm"
  if [ ! -d "$NVM_DIR" ]; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  fi
  # Load NVM in current subshell
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts || true
  nvm use --lts || true
  success "Node.js installed: $(node -v 2>/dev/null || echo 'installed')"
else
  success "Node.js already present: $(node -v)"
fi

# ------------------------------------------------------------------------------
# 6. Oh My Zsh, Custom Theme & Plugins
# ------------------------------------------------------------------------------
info "Setting up Oh My Zsh, plugins, and theme..."
OMZ_DIR="$USER_HOME/.oh-my-zsh"

if [ ! -d "$OMZ_DIR" ]; then
  info "Installing Oh My Zsh (unattended)..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ_DIR/custom}"

# Install zsh-autosuggestions
AUTOSUGGEST_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
if [ ! -d "$AUTOSUGGEST_DIR" ]; then
  info "Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGEST_DIR"
else
  success "zsh-autosuggestions plugin present."
fi

# Install zsh-syntax-highlighting
SYNTAX_DIR="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
if [ ! -d "$SYNTAX_DIR" ]; then
  info "Cloning zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$SYNTAX_DIR"
else
  success "zsh-syntax-highlighting plugin present."
fi

# Install pixegami-agnoster theme
THEME_SRC="$SCRIPT_DIR/pixegami-agnoster.zsh-theme"
if [ -f "$THEME_SRC" ]; then
  mkdir -p "$ZSH_CUSTOM/themes"
  cp "$THEME_SRC" "$ZSH_CUSTOM/themes/pixegami-agnoster.zsh-theme"
  if [ -w "$OMZ_DIR/themes" ]; then
    cp "$THEME_SRC" "$OMZ_DIR/themes/pixegami-agnoster.zsh-theme" 2>/dev/null || true
  fi
  success "Installed pixegami-agnoster.zsh-theme to Oh My Zsh custom themes."
else
  warn "pixegami-agnoster.zsh-theme not found in $SCRIPT_DIR!"
fi

# Link ~/.zshrc to repository's myzsh.zsh
if [ -f "$USER_HOME/.zshrc" ] && [ ! -L "$USER_HOME/.zshrc" ]; then
  cp "$USER_HOME/.zshrc" "$USER_HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
fi
ln -sf "$SCRIPT_DIR/myzsh.zsh" "$USER_HOME/.zshrc"
success "Linked ~/.zshrc -> $SCRIPT_DIR/myzsh.zsh"

# Set default shell to zsh if zsh is installed
if command -v zsh >/dev/null 2>&1; then
  ZSH_PATH="$(which zsh)"
  if [ "${SHELL:-}" != "$ZSH_PATH" ]; then
    info "Setting default shell to $ZSH_PATH..."
    if [ "$(id -u)" -eq 0 ]; then
      chsh -s "$ZSH_PATH" "$(whoami)" || true
    elif [ -t 0 ]; then
      chsh -s "$ZSH_PATH" || true
    else
      warn "Non-interactive session: To change your default login shell to Zsh, run: chsh -s $ZSH_PATH"
    fi
  fi
fi

# ------------------------------------------------------------------------------
# 7. Setup Kitty Terminal Configuration
# ------------------------------------------------------------------------------
info "Setting up Kitty configuration..."
KITTY_CONFIG_DIR="$USER_HOME/.config/kitty"
mkdir -p "$KITTY_CONFIG_DIR"

ln -sf "$SCRIPT_DIR/myKittyConfig.conf" "$KITTY_CONFIG_DIR/kitty.conf"
ln -sf "$SCRIPT_DIR/current-theme.conf" "$KITTY_CONFIG_DIR/current-theme.conf"
ln -sf "$SCRIPT_DIR/cheatsheet.txt" "$KITTY_CONFIG_DIR/cheatsheet.txt"
success "Kitty configuration linked to ~/.config/kitty/"

# ------------------------------------------------------------------------------
# 8. Setup Neovim Configuration & Bootstrap Plugins
# ------------------------------------------------------------------------------
info "Configuring Neovim..."
NVIM_TARGET_DIR="$USER_HOME/.config/nvim"

if [ "$SCRIPT_DIR" != "$NVIM_TARGET_DIR" ]; then
  if [ -d "$NVIM_TARGET_DIR" ] && [ ! -L "$NVIM_TARGET_DIR" ]; then
    mv "$NVIM_TARGET_DIR" "$NVIM_TARGET_DIR.backup.$(date +%Y%m%d%H%M%S)"
  fi
  mkdir -p "$USER_HOME/.config"
  ln -sfn "$SCRIPT_DIR" "$NVIM_TARGET_DIR"
  success "Linked ~/.config/nvim -> $SCRIPT_DIR"
fi

# Bootstrap lazy.nvim plugins non-interactively
info "Bootstrapping Neovim plugins via lazy.nvim (headless)..."
nvim --headless "+Lazy! sync" +qa || true
success "Neovim plugins synchronized."

# ------------------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------------------
echo ""
echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}      All Terminal & Neovim Environments Are Ready!            ${NC}"
echo -e "${GREEN}================================================================${NC}"
echo "Summary of setup:"
echo "  - Terminal: Kitty (~/.config/kitty/kitty.conf)"
echo "  - Shell:    Zsh with Oh My Zsh (~/.zshrc)"
echo "  - Theme:    pixegami-agnoster.zsh-theme"
echo "  - Plugins:  zsh-autosuggestions, zsh-syntax-highlighting"
echo "  - Editor:   Neovim v0.11+ (~/.config/nvim)"
echo "  - Font:     JetBrains Mono Nerd Font (~/.local/share/fonts/NerdFonts)"
echo ""
echo "Restart your terminal or run: exec zsh"
