#!/bin/bash
# Simple ZSH installation script

set -e

# Color codes for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== ZSH Shell Setup ===${NC}"

# Detect package manager and install zsh
echo -e "${BLUE}📦 Detecting package manager and installing ZSH...${NC}"
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    echo -e "${YELLOW}Installing ZSH (Ubuntu/Debian)...${NC}"
    sudo apt update && sudo apt install -y zsh curl git
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    echo -e "${YELLOW}Installing ZSH (Fedora)...${NC}"
    sudo dnf install -y zsh curl git
else
    echo -e "${RED}Package manager not supported. Please install zsh manually.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ ZSH installation completed${NC}"

# Install Oh My Zsh
echo -e "\n${BLUE}🎨 Installing Oh My Zsh framework...${NC}"
if [ ! -d ~/.oh-my-zsh ]; then
    echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo -e "${GREEN}✅ Oh My Zsh installed successfully${NC}"
else
    echo -e "${GREEN}✅ Oh My Zsh already installed${NC}"
fi

# Install plugins
echo -e "\n${BLUE}🔌 Installing ZSH plugins...${NC}"
echo -e "${YELLOW}Installing syntax highlighting plugin...${NC}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2>/dev/null || echo -e "${GREEN}✅ Plugin already exists${NC}"
echo -e "${YELLOW}Installing autosuggestions plugin...${NC}"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 2>/dev/null || echo -e "${GREEN}✅ Plugin already exists${NC}"
echo -e "${GREEN}✅ ZSH plugins installation completed${NC}"

# Install Starship prompt
echo -e "\n${BLUE}⭐ Installing Starship prompt...${NC}"
if ! command -v starship &> /dev/null; then
    echo -e "${YELLOW}Installing Starship prompt...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    echo -e "${GREEN}✅ Starship installed successfully${NC}"
else
    echo -e "${GREEN}✅ Starship already installed${NC}"
fi

# Install modern CLI tools and dependencies
echo -e "\n${BLUE}🔧 Installing modern CLI tools and dependencies...${NC}"

# Install system packages first
echo -e "${YELLOW}Installing tig and fzf...${NC}"
if [ "$PKG_MANAGER" = "apt" ]; then
    sudo apt install -y tig fzf
elif [ "$PKG_MANAGER" = "dnf" ]; then
    sudo dnf install -y tig fzf
fi
echo -e "${GREEN}✅ System packages installed${NC}"

# Check for Rust installation (should be installed via dev/install-essentials.sh)
echo -e "\n${BLUE}🦀 Checking Rust installation...${NC}"
if ! command -v cargo &> /dev/null; then
    echo -e "${RED}⚠️  Rust not found. Please install development essentials first:${NC}"
    echo -e "${YELLOW}     cd dev && ./install-essentials.sh${NC}"
    echo -e "${YELLOW}   Or install Rust manually:${NC}"
    echo -e "${YELLOW}     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y${NC}"
    echo -e "${YELLOW}   Then re-run this script.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Rust found, proceeding with modern CLI tools installation${NC}"
fi

# Install Rust-based modern CLI tools
echo -e "\n${BLUE}⚡ Installing modern CLI tools (eza, bat, fd-find, ripgrep)...${NC}"
if command -v cargo &> /dev/null; then
    # Source cargo environment if not already available
    [[ -f ~/.cargo/env ]] && source ~/.cargo/env
    
    echo -e "${YELLOW}Installing Rust-based CLI tools...${NC}"
    cargo install eza bat fd-find ripgrep
    echo -e "${GREEN}✅ Modern CLI tools installed successfully${NC}"
else
    echo -e "${RED}⚠ Cargo not available, skipping Rust-based tools installation${NC}"
    echo -e "${YELLOW}  You can install them later with: cargo install eza bat fd-find ripgrep${NC}"
fi

# Backup existing zshrc
echo -e "\n${BLUE}📝 Installing ZSH configuration...${NC}"
if [ -f ~/.zshrc ]; then
    echo -e "${YELLOW}Backing up existing ~/.zshrc to ~/.zshrc.backup${NC}"
    cp ~/.zshrc ~/.zshrc.backup
fi

# Copy zshrc
echo -e "${YELLOW}Installing ZSH configuration...${NC}"
cp zshrc ~/.zshrc
echo -e "${GREEN}✅ ZSH configuration installed${NC}"

# Create Projects directory
echo -e "\n${YELLOW}📁 Creating Projects directory...${NC}"
mkdir -p ~/Projects/repos
echo -e "${GREEN}✅ Projects directory created${NC}"

# Set ZSH as default shell
echo -e "\n${BLUE}🐚 Setting ZSH as default shell...${NC}"
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${YELLOW}Setting ZSH as default shell...${NC}"
    chsh -s "$(which zsh)"
    echo -e "${YELLOW}⚠ Please log out and log back in to complete shell change${NC}"
    echo -e "${GREEN}✅ ZSH set as default shell${NC}"
else
    echo -e "${GREEN}✅ ZSH already set as default shell${NC}"
fi

echo
echo -e "${GREEN}✅ ZSH configuration installed successfully${NC}"
echo -e "${BLUE}Restart terminal or run: ${YELLOW}exec zsh${NC}"
echo
echo -e "${GREEN}🎉 Features installed:${NC}"
echo -e "${BLUE}  • Starship prompt (modern cross-shell prompt)${NC}"
echo -e "${BLUE}  • Modern CLI tools: eza, bat, fd-find, ripgrep, tig, fzf${NC}"
echo -e "${BLUE}  • Enhanced Oh My Zsh plugins (jsontools, web-search, copyfile, etc.)${NC}"
echo -e "${BLUE}  • Vi mode with development aliases${NC}"
echo -e "${BLUE}  • Java version switching (setJdk17/setJdk21)${NC}"
echo -e "${BLUE}  • Git enhancements and utilities${NC}"
echo -e "${BLUE}  • Development environment utilities (Docker, PostgreSQL, etc.)${NC}"
echo -e "${BLUE}  • Performance optimizations (lazy loading)${NC}"
