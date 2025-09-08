#!/bin/bash
# Permission fix script for dotfiles installation issues

set -e

# Color codes for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Dotfiles Permission Fix ===${NC}"
echo -e "${BLUE}This script fixes common permission issues that prevent dotfiles installation.${NC}"
echo

# Check current user and home directory status
echo -e "\n${BLUE}🔍 Diagnosing permission issues...${NC}"
echo -e "${YELLOW}Current user: ${NC}$(whoami)"
echo -e "${YELLOW}Home directory: ${NC}$HOME"
echo -e "${YELLOW}Home directory owner: ${NC}$(stat -c '%U:%G' ~ 2>/dev/null || stat -f '%Su:%Sg' ~ 2>/dev/null || echo 'unknown')"
echo -e "${YELLOW}Home directory writable: ${NC}$([ -w ~ ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo

# Function to safely fix permissions
fix_permissions() {
    local path=$1
    local description=$2
    
    if [ -e "$path" ]; then
        echo -e "${YELLOW}🔧 Fixing permissions for $description ($path)...${NC}"
        sudo chown -R $USER:$USER "$path" 2>/dev/null && {
            echo -e "${GREEN}✅ Fixed permissions for $description${NC}"
        } || {
            echo -e "${RED}⚠️ Warning: Could not fix permissions for $path${NC}"
        }
    fi
}

# Ask for confirmation
echo -e "${CYAN}❓ Do you want to fix permissions for config files and directories? (y/N): ${NC}"
read -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Permission fix cancelled.${NC}"
    exit 0
fi

echo -e "\n${BLUE}🔨 Fixing permissions...${NC}"

# Fix home directory ownership (most conservative)
echo -e "\n${BLUE}🏠 Checking home directory ownership...${NC}"
if [ ! -w "$HOME" ]; then
    echo -e "${YELLOW}🔧 Fixing home directory ownership...${NC}"
    sudo chown $USER:$USER "$HOME" && {
        echo -e "${GREEN}✅ Home directory ownership fixed${NC}"
    } || {
        echo -e "${RED}❌ Failed to fix home directory ownership${NC}"
    }
else
    echo -e "${GREEN}✅ Home directory ownership is correct${NC}"
fi

# Fix common config file permissions
echo -e "\n${BLUE}📝 Fixing configuration file permissions...${NC}"
fix_permissions ~/.vimrc "Vim configuration"
fix_permissions ~/.vim "Vim directory"
fix_permissions ~/.zshrc "ZSH configuration"
fix_permissions ~/.oh-my-zsh "Oh My ZSH directory"
fix_permissions ~/.config "Config directory"
fix_permissions ~/.local "Local directory"

# Fix specific subdirectories that commonly have issues
echo -e "\n${BLUE}📁 Fixing specific application directories...${NC}"
fix_permissions ~/.config/kitty "Kitty configuration"
fix_permissions ~/.local/share/fonts "Local fonts"

# Ensure directories have correct permissions
echo -e "\n${BLUE}🔐 Setting directory permissions...${NC}"
for dir in ~/.vim ~/.config ~/.local ~/.local/share ~/.local/share/fonts; do
    if [ -d "$dir" ]; then
        echo -e "${YELLOW}Setting permissions for $dir...${NC}"
        chmod 755 "$dir" 2>/dev/null && {
            echo -e "${GREEN}✅ Directory permissions set${NC}"
        } || {
            echo -e "${RED}⚠️ Could not set directory permissions${NC}"
        }
    fi
done

# Ensure config files have correct permissions
echo -e "\n${BLUE}📄 Setting file permissions...${NC}"
for file in ~/.vimrc ~/.zshrc; do
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Setting permissions for $file...${NC}"
        chmod 644 "$file" 2>/dev/null && {
            echo -e "${GREEN}✅ File permissions set${NC}"
        } || {
            echo -e "${RED}⚠️ Could not set file permissions${NC}"
        }
    fi
done

echo
echo -e "${GREEN}✅ Permission fix completed!${NC}"
echo
echo -e "${CYAN}🚀 You can now run the install scripts:${NC}"
echo -e "${BLUE}  • ${YELLOW}./vim/install.sh${NC}"
echo -e "${BLUE}  • ${YELLOW}./kitty/install.sh${NC}"
echo -e "${BLUE}  • ${YELLOW}./zsh/install.sh${NC}"
echo -e "${BLUE}  • ${YELLOW}./fonts/install.sh${NC}"
echo
echo -e "${RED}💣 If you still have issues, try the nuclear option:${NC}"
echo -e "${YELLOW}  sudo rm -rf ~/.vimrc ~/.vim ~/.config/kitty ~/.zshrc ~/.oh-my-zsh${NC}"
echo -e "${YELLOW}  Then run the install scripts again.${NC}"
