#!/bin/bash
# Permission fix script for dotfiles installation issues

set -e

echo "=== Dotfiles Permission Fix ==="
echo "This script fixes common permission issues that prevent dotfiles installation."
echo

# Check current user and home directory status
echo "Diagnosing permission issues..."
echo "Current user: $(whoami)"
echo "Home directory: $HOME"
echo "Home directory owner: $(stat -c '%U:%G' ~ 2>/dev/null || stat -f '%Su:%Sg' ~ 2>/dev/null || echo 'unknown')"
echo "Home directory writable: $([ -w ~ ] && echo 'Yes' || echo 'No')"
echo

# Function to safely fix permissions
fix_permissions() {
    local path=$1
    local description=$2
    
    if [ -e "$path" ]; then
        echo "Fixing permissions for $description ($path)..."
        sudo chown -R $USER:$USER "$path" 2>/dev/null || {
            echo "Warning: Could not fix permissions for $path"
        }
    fi
}

# Ask for confirmation
read -p "Do you want to fix permissions for config files and directories? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Permission fix cancelled."
    exit 0
fi

echo "Fixing permissions..."

# Fix home directory ownership (most conservative)
if [ ! -w "$HOME" ]; then
    echo "Fixing home directory ownership..."
    sudo chown $USER:$USER "$HOME"
fi

# Fix common config file permissions
fix_permissions ~/.vimrc "Vim configuration"
fix_permissions ~/.vim "Vim directory"
fix_permissions ~/.zshrc "ZSH configuration"
fix_permissions ~/.oh-my-zsh "Oh My ZSH directory"
fix_permissions ~/.config "Config directory"
fix_permissions ~/.local "Local directory"

# Fix specific subdirectories that commonly have issues
fix_permissions ~/.config/kitty "Kitty configuration"
fix_permissions ~/.local/share/fonts "Local fonts"

# Ensure directories have correct permissions
echo "Setting directory permissions..."
for dir in ~/.vim ~/.config ~/.local ~/.local/share ~/.local/share/fonts; do
    if [ -d "$dir" ]; then
        chmod 755 "$dir" 2>/dev/null || true
    fi
done

# Ensure config files have correct permissions
echo "Setting file permissions..."
for file in ~/.vimrc ~/.zshrc; do
    if [ -f "$file" ]; then
        chmod 644 "$file" 2>/dev/null || true
    fi
done

echo
echo "✓ Permission fix completed!"
echo
echo "You can now run the install scripts:"
echo "  ./vim/install.sh"
echo "  ./kitty/install.sh"
echo "  ./zsh/install.sh"
echo "  ./fonts/install.sh"
echo
echo "If you still have issues, try the nuclear option:"
echo "  sudo rm -rf ~/.vimrc ~/.vim ~/.config/kitty ~/.zshrc ~/.oh-my-zsh"
echo "  Then run the install scripts again."
