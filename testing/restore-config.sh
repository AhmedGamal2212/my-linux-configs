#!/bin/bash

# ===================================================================
# Restore Configuration from Backup
# Created with ☕ by Ahmed Gamal (Gemmy)
# GitHub: https://github.com/AhmedGamal2212
# ===================================================================

# Color codes for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

if [ -z "$1" ]; then
    echo -e "${RED}❌ Usage: ./restore-config.sh <backup_directory>${NC}"
    echo -e "${YELLOW}Example: ${BLUE}./restore-config.sh ~/.config-backup-20241201-143025${NC}"
    exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}❌ Backup directory not found: ${YELLOW}$BACKUP_DIR${NC}"
    exit 1
fi

echo -e "${CYAN}🔄 Restoring configuration from: ${BLUE}$BACKUP_DIR${NC}"
echo
echo -e "${YELLOW}📦 Restoring configuration files...${NC}"
echo

# Restore ZSH config
if [ -f "$BACKUP_DIR/zshrc.backup" ]; then
    cp "$BACKUP_DIR/zshrc.backup" ~/.zshrc
    echo -e "${GREEN}✅ ZSH config restored${NC}"
fi

if [ -f "$BACKUP_DIR/zshrc.local.backup" ]; then
    cp "$BACKUP_DIR/zshrc.local.backup" ~/.zshrc.local
    echo -e "${GREEN}✅ ZSH local config restored${NC}"
fi

# Restore Oh My Zsh
if [ -d "$BACKUP_DIR/oh-my-zsh.backup" ]; then
    rm -rf ~/.oh-my-zsh
    cp -r "$BACKUP_DIR/oh-my-zsh.backup" ~/.oh-my-zsh
    echo -e "${GREEN}✅ Oh My Zsh restored${NC}"
fi

# Restore Vim config
if [ -f "$BACKUP_DIR/vimrc.backup" ]; then
    cp "$BACKUP_DIR/vimrc.backup" ~/.vimrc
    echo -e "${GREEN}✅ Vim config restored${NC}"
fi

# Restore Kitty config
if [ -f "$BACKUP_DIR/kitty.conf.backup" ]; then
    mkdir -p ~/.config/kitty
    cp "$BACKUP_DIR/kitty.conf.backup" ~/.config/kitty/kitty.conf
    echo -e "${GREEN}✅ Kitty config restored${NC}"
fi

# Restore starship config
if [ -f "$BACKUP_DIR/starship.toml.backup" ]; then
    mkdir -p ~/.config
    cp "$BACKUP_DIR/starship.toml.backup" ~/.config/starship.toml
    echo -e "${GREEN}✅ Starship config restored${NC}"
fi

# Restore shell
if [ -f "$BACKUP_DIR/current_shell.txt" ]; then
    ORIGINAL_SHELL=$(cat "$BACKUP_DIR/current_shell.txt")
    chsh -s "$ORIGINAL_SHELL"
    echo -e "${GREEN}✅ Shell restored to: ${YELLOW}$ORIGINAL_SHELL${NC}"
fi

echo
echo -e "${GREEN}✅ Configuration restored successfully!${NC}"
echo -e "${CYAN}🔄 Please restart your terminal or run: ${BLUE}exec zsh${NC}"
echo
echo -e "${PURPLE}Welcome back to your original setup! 🎉${NC}"
