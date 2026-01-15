#!/bin/bash

# Define variables
REPO_URL="https://github.com/s-aravindh/dev_setup"
TEMP_DIR=$(mktemp -d)
WEZTERM_CONFIG_DIR="$HOME/.config/wezterm"
STARSHIP_CONFIG_PATH="$HOME/.config/starship.toml"
ZSHRC="$HOME/.zshrc"

echo "----------------------------------------------------------------"
echo "  Starting Mac Developer Setup (Essentials Only)                "
echo "----------------------------------------------------------------"

# --- 1. System Checks ---
echo "Checking prerequisites..."
if ! command -v brew &> /dev/null; then
    echo "📦 Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$ZSHRC"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

if ! command -v zsh &> /dev/null; then
    echo "❌ Zsh not found. This setup requires Zsh."
    exit 1
fi

# --- 2. Install Core Tools ---
echo "📦 Installing core tools..."
brew update

# Terminal & Shell
brew install --cask wezterm
brew install starship
brew install zsh-syntax-highlighting zsh-autosuggestions

# --- 3. Install Fonts ---
echo "🔤 Installing Developer Fonts..."
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-cascadia-code
brew install --cask font-cascadia-code-nerd-font
brew install --cask font-fira-code
brew install --cask font-hack-nerd-font
brew install --cask font-meslo-lg-nerd-font

# --- 4. Install Terminal Utilities ---
echo "🛠️  Installing Terminal Utilities..."
brew install git
brew install gh                    # GitHub CLI
brew install lazygit               # Terminal UI for git
brew install fzf                   # Fuzzy finder
brew install ripgrep               # Fast grep (rg)
brew install fd                    # Fast find
brew install bat                   # Better cat
brew install eza                   # Better ls
brew install zoxide                # Smarter cd
brew install tldr                  # Simplified man pages
brew install jq                    # JSON processor
brew install htop                  # Process viewer
brew install tree                  # Directory tree
brew install wget
brew install curl
brew install neovim                # Modern vim

# --- 5. Fetch Configuration from GitHub ---
echo "⬇️  Cloning configuration repository..."
if ! git clone --depth 1 "$REPO_URL" "$TEMP_DIR"; then
    echo "❌ Failed to clone repository."
    rm -rf "$TEMP_DIR"
    exit 1
fi

if [ ! -d "$TEMP_DIR/wezterm" ]; then
    echo "❌ Failed to download configuration files."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# --- 6. Setup WezTerm ---
echo "⚙️  Configuring WezTerm..."
mkdir -p "$WEZTERM_CONFIG_DIR"
cp -r "$TEMP_DIR/wezterm/"* "$WEZTERM_CONFIG_DIR/"

if [ -f "$TEMP_DIR/dark-desert.jpg" ]; then
    echo "🖼️  Copying background image..."
    cp "$TEMP_DIR/dark-desert.jpg" "$WEZTERM_CONFIG_DIR/"
else
    echo "⚠️  Warning: Background image 'dark-desert.jpg' not found in repo."
fi

# --- 7. Setup Starship ---
echo "🚀 Configuring Starship..."
mkdir -p "$HOME/.config"
cp "$TEMP_DIR/starship/starship.toml" "$STARSHIP_CONFIG_PATH"

# --- 8. Update Zshrc ---
echo "📝 Updating .zshrc..."

if [ ! -f "$ZSHRC" ]; then
    touch "$ZSHRC"
    echo "   (Created new .zshrc file)"
else
    BACKUP_TIMESTAMP=$(date +%s)
    BACKUP_FILE="$ZSHRC.backup.$BACKUP_TIMESTAMP"
    cp "$ZSHRC" "$BACKUP_FILE"
    echo "   (Backup created at $BACKUP_FILE)"
fi

# Add Starship init if not present
if ! grep -q "starship init zsh" "$ZSHRC" 2>/dev/null; then
    echo >> "$ZSHRC"
    echo '# --- Starship Initialization ---' >> "$ZSHRC"
    echo 'eval "$(starship init zsh)"' >> "$ZSHRC"
fi

# Add Plugins if not present
if ! grep -q "zsh-syntax-highlighting" "$ZSHRC" 2>/dev/null; then
    echo >> "$ZSHRC"
    echo '# --- Zsh Plugins ---' >> "$ZSHRC"
    echo 'source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"' >> "$ZSHRC"
    echo 'source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"' >> "$ZSHRC"
    echo 'ZSH_HIGHLIGHT_STYLES[cursor]=none' >> "$ZSHRC"
fi

# Add useful aliases if not present
if ! grep -q "# --- Aliases ---" "$ZSHRC" 2>/dev/null; then
    echo >> "$ZSHRC"
    echo '# --- Aliases ---' >> "$ZSHRC"
    echo 'alias ls="eza --icons"' >> "$ZSHRC"
    echo 'alias ll="eza -la --icons"' >> "$ZSHRC"
    echo 'alias lt="eza --tree --icons"' >> "$ZSHRC"
    echo 'alias cat="bat"' >> "$ZSHRC"
    echo 'alias cd="z"' >> "$ZSHRC"
    echo 'alias vim="nvim"' >> "$ZSHRC"
    echo 'alias lg="lazygit"' >> "$ZSHRC"
fi

# Add zoxide init if not present
if ! grep -q "zoxide init" "$ZSHRC" 2>/dev/null; then
    echo >> "$ZSHRC"
    echo '# --- Zoxide Initialization ---' >> "$ZSHRC"
    echo 'eval "$(zoxide init zsh)"' >> "$ZSHRC"
fi

# Add fzf init if not present
if ! grep -q "fzf --zsh" "$ZSHRC" 2>/dev/null; then
    echo >> "$ZSHRC"
    echo '# --- FZF Initialization ---' >> "$ZSHRC"
    echo 'source <(fzf --zsh)' >> "$ZSHRC"
fi

# --- 9. Setup Git Config ---
echo "🔧 Setting up Git configuration..."
read -p "Enter your Git username (or press Enter to skip): " git_username
read -p "Enter your Git email (or press Enter to skip): " git_email

if [ -n "$git_username" ] && [ -n "$git_email" ]; then
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global core.editor "nvim"
    git config --global pull.rebase false
    echo "   ✅ Git configured for $git_username <$git_email>"
else
    echo "   ⚠️  Skipped Git configuration"
fi

# --- 10. macOS Settings ---
echo "🍎 Applying macOS settings..."

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Restart Finder to apply changes
killall Finder 2>/dev/null

# --- 11. Cleanup & Finish ---
echo "🧹 Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "----------------------------------------------------------------"
echo "✅ Setup Complete!"
echo ""
echo "   Installed:"
echo "   • Fonts: JetBrains Mono, Cascadia Code, Fira Code, Hack, Meslo"
echo "   • Terminal: WezTerm, Starship, neovim"
echo "   • CLI Tools: git, gh, lazygit, fzf, ripgrep, fd, bat, eza, zoxide"
echo ""
echo "   Next steps:"
echo "   1. Restart your terminal (or run: source ~/.zshrc)"
echo "   2. Login to GitHub CLI: gh auth login"
echo "----------------------------------------------------------------"