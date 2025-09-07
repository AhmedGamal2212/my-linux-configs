#!/bin/bash
# Simple ZSH installation script

set -e

echo "=== ZSH Shell Setup ==="

# Detect package manager and install zsh
if command -v apt &> /dev/null; then
    echo "Installing ZSH (Ubuntu/Debian)..."
    sudo apt update && sudo apt install -y zsh curl git
elif command -v dnf &> /dev/null; then
    echo "Installing ZSH (Fedora)..."
    sudo dnf install -y zsh curl git
else
    echo "Package manager not supported. Please install zsh manually."
    exit 1
fi

# Install Oh My Zsh
if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install plugins
echo "Installing ZSH plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2>/dev/null || echo "Plugin already exists"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 2>/dev/null || echo "Plugin already exists"

# Install Starship prompt
echo "Installing Starship prompt..."
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    echo "✓ Starship installed successfully"
else
    echo "Starship already installed"
fi

# Install modern CLI tools and dependencies
echo "Installing modern CLI tools and dependencies..."

# Install system packages first
if [ "$PKG_MANAGER" = "apt" ]; then
    sudo apt install -y tig fzf
elif [ "$PKG_MANAGER" = "dnf" ]; then
    sudo dnf install -y tig fzf
fi

# Install Rust (for modern CLI tools)
if ! command -v cargo &> /dev/null; then
    echo "Installing Rust (required for modern CLI tools)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    echo "✓ Rust installed successfully"
fi

# Install Rust-based modern CLI tools
echo "Installing modern CLI tools (eza, bat, fd-find, ripgrep)..."
if command -v cargo &> /dev/null; then
    # Source cargo environment if not already available
    [[ -f ~/.cargo/env ]] && source ~/.cargo/env
    
    cargo install eza bat fd-find ripgrep
    echo "✓ Modern CLI tools installed successfully"
else
    echo "⚠ Cargo not available, skipping Rust-based tools installation"
    echo "  You can install them later with: cargo install eza bat fd-find ripgrep"
fi

# Backup existing zshrc
if [ -f ~/.zshrc ]; then
    echo "Backing up existing ~/.zshrc to ~/.zshrc.backup"
    cp ~/.zshrc ~/.zshrc.backup
fi

# Copy zshrc
echo "Installing ZSH configuration..."
cp zshrc ~/.zshrc

# Create Projects directory
mkdir -p ~/Projects/repos

# Set ZSH as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting ZSH as default shell..."
    chsh -s "$(which zsh)"
    echo "⚠ Please log out and log back in to complete shell change"
fi

echo "✓ ZSH configuration installed successfully"
echo "Restart terminal or run: exec zsh"
echo ""
echo "🎉 Features installed:"
echo "  • Starship prompt (modern cross-shell prompt)"
echo "  • Modern CLI tools: eza, bat, fd-find, ripgrep, tig, fzf"
echo "  • Enhanced Oh My Zsh plugins (jsontools, web-search, copyfile, etc.)"
echo "  • Vi mode with development aliases"
echo "  • Java version switching (setJdk17/setJdk21)"
echo "  • Git enhancements and utilities"
echo "  • Development environment utilities (Docker, PostgreSQL, etc.)"
echo "  • Performance optimizations (lazy loading)"
