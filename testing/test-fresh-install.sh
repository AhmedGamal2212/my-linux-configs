#!/bin/bash

# ===================================================================
# Test Fresh Installation Simulation
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

echo -e "${CYAN}🧪 Testing Fresh Installation${NC}"
echo -e "${CYAN}==============================${NC}"
echo

echo -e "${PURPLE}📋 Available Testing Methods:${NC}"
echo
echo -e "${BLUE}🔧 Option 1: Backup & Clean Test${NC}"
echo -e "1. Backup current config: ${YELLOW}./backup-current-config.sh${NC}"
echo -e "2. Remove current configs to simulate fresh system"
echo -e "3. Run installation: ${YELLOW}../install.sh${NC}"
echo -e "4. Test the result"
echo -e "5. Restore original: ${YELLOW}./restore-config.sh <backup-dir>${NC}"
echo

echo -e "${BLUE}👤 Option 2: New User Test${NC}"
echo -e "Create a test user to simulate completely fresh environment:"
echo -e "${YELLOW}sudo adduser testuser${NC}"
echo -e "${YELLOW}sudo su - testuser${NC}"
echo -e "${YELLOW}git clone <your-repo> && cd my-linux-configs${NC}"
echo -e "${YELLOW}./install.sh${NC}"
echo

echo -e "${BLUE}🐳 Option 3: Docker Test${NC}"
echo -e "Test in isolated Docker container:"
echo -e "${YELLOW}docker run -it --rm ubuntu:22.04 bash${NC}"
echo -e "# Then install git, clone repo, and run script"
echo

echo -e "${PURPLE}⚡ Quick Clean Simulation (Current User):${NC}"
read -p "Remove current configs for testing? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🔄 Cleaning current configs...${NC}"
    echo
    
    # Backup first
    ./backup-current-config.sh
    
    echo
    echo -e "${YELLOW}🗑️  Removing current configurations...${NC}"
    
    # Remove configs (but keep backups)
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
        echo -e "${GREEN}✅ ZSH config removed${NC}"
    fi
    
    if [ -d ~/.oh-my-zsh ]; then
        rm -rf ~/.oh-my-zsh
        echo -e "${GREEN}✅ Oh My Zsh removed${NC}"
    fi
    
    if [ -f ~/.vimrc ]; then
        rm ~/.vimrc
        echo -e "${GREEN}✅ Vim config removed${NC}"
    fi
    
    if [ -f ~/.config/kitty/kitty.conf ]; then
        rm -f ~/.config/kitty/kitty.conf
        echo -e "${GREEN}✅ Kitty config removed${NC}"
    fi
    
    if [ -f ~/.config/starship.toml ]; then
        rm -f ~/.config/starship.toml
        echo -e "${GREEN}✅ Starship config removed${NC}"
    fi
    
    echo
    echo -e "${GREEN}✅ Configs removed. Now run: ${BLUE}../install.sh${NC}"
    echo -e "${YELLOW}💡 After testing, restore with the backup script shown above${NC}"
    echo -e "${PURPLE}Ready for fresh installation! 🚀${NC}"
else
    echo -e "${RED}❌ Test cancelled${NC}"
fi
