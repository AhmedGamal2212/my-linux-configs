#!/bin/bash

# ===================================================================
# Clean All Testing Artifacts and Restore Clean State
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

echo -e "${CYAN}🧹 Cleaning Testing Backup Directories${NC}"
echo -e "${CYAN}======================================${NC}"
echo

echo -e "${YELLOW}📁 This will remove:${NC}"
echo -e "• All backup directories created by testing scripts (~/.config-backup-*)"
echo -e "• Temporary testing artifacts"
echo
echo -e "${GREEN}✅ Your current configuration files will remain untouched${NC}"
echo
read -p "Remove testing backup directories? [y/N]: " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Cleaning cancelled${NC}"
    exit 0
fi

echo
echo -e "${YELLOW}🗑️  Removing backup directories...${NC}"

# Remove all backup directories
BACKUP_COUNT=0
for backup_dir in ~/.config-backup-*; do
    if [ -d "$backup_dir" ]; then
        rm -rf "$backup_dir"
        echo -e "${GREEN}✅ Removed: ${BLUE}$(basename "$backup_dir")${NC}"
        ((BACKUP_COUNT++))
    fi
done

if [ $BACKUP_COUNT -eq 0 ]; then
    echo -e "${YELLOW}📁 No backup directories found${NC}"
else
    echo -e "${GREEN}✅ Removed $BACKUP_COUNT backup directories${NC}"
fi

# Note: Current configuration files are preserved
echo -e "${GREEN}💡 Your current configs (~/.zshrc, ~/.vimrc, etc.) remain untouched${NC}"

echo
echo -e "${YELLOW}🧹 Cleaning installed programs (optional)...${NC}"
read -p "Remove installed programs (starship, modern CLI tools, etc.)? [y/N]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🗑️  Removing installed programs...${NC}"
    
    # Remove Starship
    if command -v starship &> /dev/null; then
        sudo rm -f /usr/local/bin/starship
        echo -e "${GREEN}✅ Starship removed${NC}"
    fi
    
    # Remove Rust programs if installed via cargo
    if [ -d ~/.cargo ]; then
        echo -e "${YELLOW}Found Rust/Cargo installation${NC}"
        echo -e "${BLUE}💡 You may want to manually remove: ~/.cargo and ~/.rustup${NC}"
    fi
    
    # Note about package manager installations
    echo -e "${BLUE}💡 Package manager tools (bat, fd, rg, eza) should be removed via:${NC}"
    echo -e "   ${YELLOW}Ubuntu/Debian: sudo apt remove bat fd-find ripgrep${NC}"
    echo -e "   ${YELLOW}Fedora: sudo dnf remove bat fd-find ripgrep${NC}"
else
    echo -e "${BLUE}💡 Installed programs kept (starship, modern CLI tools, etc.)${NC}"
fi

echo
echo -e "${GREEN}✅ Testing cleanup completed!${NC}"
echo -e "${CYAN}📁 All testing backup directories removed${NC}"
echo
echo -e "${PURPLE}✨ Clean testing environment ready!${NC}"
echo
echo -e "${BLUE}💡 Your current configuration is preserved and ready for more testing${NC}"
