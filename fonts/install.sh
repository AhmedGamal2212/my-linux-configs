#!/bin/bash
# Simple font installation script

set -e

# Color codes for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Font Installation ===${NC}"

# Create fonts directory
echo -e "${BLUE}📁 Creating fonts directory...${NC}"
mkdir -p ~/.local/share/fonts
echo -e "${GREEN}✅ Fonts directory created${NC}"

# Function to download and install font
install_font() {
    local name=$1
    local url=$2
    local extract_path=$3
    
    echo -e "${YELLOW}Installing $name...${NC}"
    
    # Download
    wget -q -O /tmp/$name.zip "$url" || { echo -e "${RED}Failed to download $name${NC}"; return 1; }
    
    # Extract
    unzip -q /tmp/$name.zip -d /tmp/$name/
    
    # Copy TTF files
    find /tmp/$name/$extract_path -name "*.ttf" -exec cp {} ~/.local/share/fonts/ \; 2>/dev/null
    
    # Cleanup
    rm -rf /tmp/$name*
    
    echo -e "${GREEN}✅ $name installed${NC}"
}

# Try package manager first
echo -e "\n${BLUE}📦 Trying package manager installation...${NC}"
if command -v apt &> /dev/null; then
    echo -e "${YELLOW}Trying package installation (Ubuntu/Debian)...${NC}"
    sudo apt update
    sudo apt install -y fonts-firacode 2>/dev/null || echo -e "${YELLOW}Fira Code not in repos, using manual install${NC}"
elif command -v dnf &> /dev/null; then
    echo -e "${YELLOW}Trying package installation (Fedora)...${NC}"
    sudo dnf install -y fira-code-fonts 2>/dev/null || echo -e "${YELLOW}Fira Code not in repos, using manual install${NC}"
fi

# Manual installation as backup
echo -e "\n${BLUE}🔤 Installing programming fonts...${NC}"
if ! fc-list | grep -qi "fira code"; then
    echo -e "${YELLOW}Installing Fira Code manually...${NC}"
    install_font "FiraCode" \
        "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip" \
        "ttf"
else
    echo -e "${GREEN}✅ Fira Code already installed${NC}"
fi

# Install JetBrains Mono as backup
if ! fc-list | grep -qi "jetbrains mono"; then
    echo -e "${YELLOW}Installing JetBrains Mono as backup...${NC}"
    install_font "JetBrainsMono" \
        "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip" \
        "fonts/ttf"
else
    echo -e "${GREEN}✅ JetBrains Mono already installed${NC}"
fi

# Update font cache
echo -e "\n${BLUE}🔄 Updating font cache...${NC}"
fc-cache -f
echo -e "${GREEN}✅ Font cache updated${NC}"

echo
echo -e "${GREEN}✅ Font installation completed${NC}"
echo -e "${BLUE}Available fonts:${NC}"
fc-list | grep -E "(Fira|JetBrains)" | cut -d: -f2 | sort -u | head -10
