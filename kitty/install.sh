#!/bin/bash
# Simple Kitty terminal installation script

set -e

echo "=== Kitty Terminal Setup ==="

# Detect package manager and install kitty
if command -v apt &> /dev/null; then
    echo "Installing Kitty terminal (Ubuntu/Debian)..."
    sudo apt update && sudo apt install -y kitty
elif command -v dnf &> /dev/null; then
    echo "Installing Kitty terminal (Fedora)..."
    sudo dnf install -y kitty
else
    echo "Package manager not supported. Please install kitty manually."
    exit 1
fi

# Create config directory
mkdir -p ~/.config/kitty

# Backup existing config
if [ -f ~/.config/kitty/kitty.conf ]; then
    echo "Backing up existing kitty.conf to kitty.conf.backup"
    cp ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.backup
fi

# Copy configuration
echo "Installing kitty configuration..."
cp kitty.conf ~/.config/kitty/kitty.conf

echo "✓ Kitty terminal installed successfully"
echo "Launch with: kitty"
echo "Key shortcuts: Ctrl+Shift+T (new tab), Ctrl+Shift+Enter (new window)"
echo "Note: Install Fira Code font for best experience (run fonts/install.sh)"
