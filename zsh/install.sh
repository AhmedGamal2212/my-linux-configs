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
echo "Features: Vi mode, development aliases, Java version switching"
