#!/bin/bash
# Simple font installation script

set -e

echo "=== Font Installation ==="

# Create fonts directory
mkdir -p ~/.local/share/fonts

# Function to download and install font
install_font() {
    local name=$1
    local url=$2
    local extract_path=$3
    
    echo "Installing $name..."
    
    # Download
    wget -q -O /tmp/$name.zip "$url" || { echo "Failed to download $name"; return 1; }
    
    # Extract
    unzip -q /tmp/$name.zip -d /tmp/$name/
    
    # Copy TTF files
    find /tmp/$name/$extract_path -name "*.ttf" -exec cp {} ~/.local/share/fonts/ \; 2>/dev/null
    
    # Cleanup
    rm -rf /tmp/$name*
    
    echo "✓ $name installed"
}

# Try package manager first
if command -v apt &> /dev/null; then
    echo "Trying package installation (Ubuntu/Debian)..."
    sudo apt update
    sudo apt install -y fonts-firacode 2>/dev/null || echo "Fira Code not in repos, using manual install"
elif command -v dnf &> /dev/null; then
    echo "Trying package installation (Fedora)..."
    sudo dnf install -y fira-code-fonts 2>/dev/null || echo "Fira Code not in repos, using manual install"
fi

# Manual installation as backup
if ! fc-list | grep -qi "fira code"; then
    echo "Installing Fira Code manually..."
    install_font "FiraCode" \
        "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip" \
        "ttf"
fi

# Install JetBrains Mono as backup
if ! fc-list | grep -qi "jetbrains mono"; then
    echo "Installing JetBrains Mono as backup..."
    install_font "JetBrainsMono" \
        "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip" \
        "fonts/ttf"
fi

# Update font cache
echo "Updating font cache..."
fc-cache -f

echo "✓ Font installation completed"
echo "Available fonts:"
fc-list | grep -E "(Fira|JetBrains)" | cut -d: -f2 | sort -u | head -10
