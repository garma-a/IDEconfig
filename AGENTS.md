# AGENTS.md: Terminal & Neovim Environment Setup Guide

This document is written for **LLM agents** (Claude, Gemini, ChatGPT, Codex, Cursor, Windsurf, OpenCode, Aider, etc.) setting up this developer environment on a fresh Linux machine from scratch.

---

## 🚀 Quick Setup (One-Command Automated)

Run the included automated setup script:

```bash
chmod +x ./setup.sh
./setup.sh
```

The script is **safe, idempotent, and non-interactive**. It automatically detects the Linux distribution, installs all required system packages, sets up Kitty, Zsh, plugins, the custom theme, downloads a Nerd Font, installs modern Neovim (v0.11+), and bootstraps all Neovim plugins headlessly.

---

## 🐧 Supported Distributions

The setup script and manual steps support:
- **Ubuntu / Debian / Linux Mint / Pop!_OS** (`apt`)
- **Arch Linux / Anarchy / Manjaro / EndeavourOS** (`pacman`)
- **Fedora / RHEL / CentOS** (`dnf`)
- **openSUSE** (`zypper`)

---

## 📋 What This Environment Includes

| Component | Tool / Config | Source in Repo | Target Path |
|---|---|---|---|
| **Terminal** | Kitty | `myKittyConfig.conf`, `current-theme.conf`, `cheatsheet.txt` | `~/.config/kitty/` |
| **Shell** | Zsh | `myzsh.zsh` | `~/.zshrc` |
| **Framework** | Oh My Zsh | Installed from official script | `~/.oh-my-zsh/` |
| **Theme** | pixegami-agnoster | `pixegami-agnoster.zsh-theme` | `~/.oh-my-zsh/themes/` |
| **Autocomplete** | zsh-autosuggestions | Cloned from GitHub | `~/.oh-my-zsh/custom/plugins/zsh-autosuggestions` |
| **Highlighting** | zsh-syntax-highlighting | Cloned from GitHub | `~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting` |
| **Editor** | Neovim (v0.11+) | `init.lua`, `lua/`, `lazy-lock.json` | `~/.config/nvim/` |
| **Icons & Font** | JetBrains Mono Nerd Font | GitHub Releases | `~/.local/share/fonts/NerdFonts/` |

---

## 🛠️ Step-by-Step Manual Instructions (Reference for Agents)

If you cannot run `./setup.sh` directly or need to execute steps manually:

### 1. Install System Dependencies

**Ubuntu / Debian**:
```bash
sudo apt-get update -y
sudo apt-get install -y git curl wget zsh kitty build-essential make gcc ripgrep fd-find xclip unzip tar fontconfig
# Ensure 'fd' is on PATH (Debian packages it as fdfind)
mkdir -p ~/.local/bin
[ ! -f ~/.local/bin/fd ] && ln -s $(which fdfind) ~/.local/bin/fd
```

**Arch Linux / Anarchy / Manjaro**:
```bash
sudo pacman -Syu --noconfirm --needed git curl wget zsh kitty base-devel make gcc ripgrep fd xclip unzip tar fontconfig neovim ttf-jetbrains-mono-nerd
```

**Fedora**:
```bash
sudo dnf install -y git curl wget zsh kitty gcc gcc-c++ make ripgrep fd-find xclip unzip tar fontconfig
```

---

### 2. Install Neovim (>= 0.10.0 required, v0.11 recommended)

> [!IMPORTANT]
> Do NOT use `apt install neovim` on Ubuntu, as it installs an outdated version (< 0.10) that will crash with this configuration.

Install the official pre-built binary:
```bash
ARCH="$(uname -m)"
[ "$ARCH" = "x86_64" ] && NVIM_ARCH="linux-x86_64" || NVIM_ARCH="linux-arm64"
curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-${NVIM_ARCH}.tar.gz" -o /tmp/nvim.tar.gz
sudo rm -rf /opt/nvim && sudo mkdir -p /opt/nvim
sudo tar -xzf /tmp/nvim.tar.gz -C /opt/nvim --strip-components=1
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
rm -f /tmp/nvim.tar.gz
```

Verify version:
```bash
nvim --version | head -n 1
```

---

### 3. Install JetBrains Mono Nerd Font

Required for Neovim file icons (`nvim-web-devicons`) and prompt symbols (`\ue0b0`):
```bash
mkdir -p ~/.local/share/fonts/NerdFonts
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -o /tmp/JetBrainsMono.tar.xz
tar -xJf /tmp/JetBrainsMono.tar.xz -C ~/.local/share/fonts/NerdFonts
fc-cache -fv ~/.local/share/fonts/NerdFonts
rm -f /tmp/JetBrainsMono.tar.xz
```

---

### 4. Install Node.js (via NVM)

Required for Mason language servers (eslint, prettier, tailwindcss, etc.):
```bash
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts
fi
```

---

### 5. Setup Zsh, Oh My Zsh, Custom Theme & Plugins

```bash
# 1. Install Oh My Zsh non-interactively
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 2. Clone custom plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true

# 3. Copy custom pixegami-agnoster theme
REPO_DIR="$(pwd)"
cp "$REPO_DIR/pixegami-agnoster.zsh-theme" ~/.oh-my-zsh/themes/pixegami-agnoster.zsh-theme
mkdir -p ~/.oh-my-zsh/custom/themes
cp "$REPO_DIR/pixegami-agnoster.zsh-theme" ~/.oh-my-zsh/custom/themes/pixegami-agnoster.zsh-theme

# 4. Link .zshrc
ln -sf "$REPO_DIR/myzsh.zsh" ~/.zshrc

# 5. Set default shell to zsh
sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null || chsh -s "$(which zsh)" 2>/dev/null || true
```

---

### 6. Link Kitty Terminal Configuration

```bash
mkdir -p ~/.config/kitty
REPO_DIR="$(pwd)"
ln -sf "$REPO_DIR/myKittyConfig.conf" ~/.config/kitty/kitty.conf
ln -sf "$REPO_DIR/current-theme.conf" ~/.config/kitty/current-theme.conf
ln -sf "$REPO_DIR/cheatsheet.txt" ~/.config/kitty/cheatsheet.txt
```

---

### 7. Link Neovim Config & Sync Plugins

```bash
REPO_DIR="$(pwd)"
# If repo was cloned to a location other than ~/.config/nvim:
if [ "$REPO_DIR" != "$HOME/.config/nvim" ]; then
  mkdir -p ~/.config
  ln -sfn "$REPO_DIR" ~/.config/nvim
fi

# Bootstrap plugins headlessly
nvim --headless "+Lazy! sync" +qa
```

---

## ✅ Verification Checklist for Agents

To verify the setup is 100% complete:

1. **Neovim**: Run `nvim --version` -> ensure version is `>= 0.10` (ideally `v0.11`).
2. **Kitty**: Run `kitty --version` and verify `~/.config/kitty/kitty.conf` exists.
3. **Zsh**: Run `zsh -c 'echo $ZSH'` -> should output `$HOME/.oh-my-zsh`.
4. **Theme**: Check that `~/.oh-my-zsh/themes/pixegami-agnoster.zsh-theme` exists.
5. **Plugins**: Check that `~/.oh-my-zsh/custom/plugins/zsh-autosuggestions` and `zsh-syntax-highlighting` exist.
6. **Fonts**: Run `fc-list : family | grep -i "nerd font"` -> should list JetBrains Mono or installed Nerd Font.
7. **Lazy Plugins**: Run `nvim --headless "+Lazy check" +qa` -> should report all plugins loaded cleanly without error.
