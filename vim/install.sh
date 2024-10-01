#!/bin/bash
# Simple Vim installation script

set -e

echo "=== Vim Configuration Setup ==="

# Detect package manager and install vim with clipboard support
if command -v apt &> /dev/null; then
    echo "Installing vim with clipboard support (Ubuntu/Debian)..."
    sudo apt update && sudo apt install -y vim-gtk3 xclip
elif command -v dnf &> /dev/null; then
    echo "Installing vim with clipboard support (Fedora)..."
    sudo dnf install -y vim-enhanced xclip
else
    echo "Package manager not supported. Please install vim with clipboard support manually."
    exit 1
fi

# Backup existing vimrc
if [ -f ~/.vimrc ]; then
    echo "Backing up existing ~/.vimrc to ~/.vimrc.backup"
    cp ~/.vimrc ~/.vimrc.backup
fi

# Copy vimrc
echo "Installing vim configuration..."
cp vimrc ~/.vimrc

# Create undo directory
mkdir -p ~/.vim/undo

# Verify installation
if vim --version | grep -q "+clipboard"; then
    echo "✓ Vim installed successfully with clipboard support"
else
    echo "⚠ Vim installed but clipboard support may not be available"
fi

echo "✓ Vim configuration installed"
echo "Usage: vim filename"
echo "Key shortcuts: jj (exit insert), ,y (copy to clipboard), ,p (paste from clipboard)"
