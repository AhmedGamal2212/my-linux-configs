#!/bin/bash
# Essential development environment installation script

set -e

# Color codes for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Essential Development Environment Setup ===${NC}"
echo -e "${BLUE}Installing core development tools and programming languages...${NC}"
echo

# Detect package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    UPDATE_CMD="sudo apt update"
    INSTALL_CMD="sudo apt install -y"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    UPDATE_CMD="sudo dnf update -y"
    INSTALL_CMD="sudo dnf install -y"
else
    echo "❌ Unsupported package manager. This script supports apt (Ubuntu/Debian) and dnf (Fedora)."
    exit 1
fi

echo -e "${BLUE}📦 Detected package manager: $PKG_MANAGER${NC}"
echo

# Update package lists
echo -e "${YELLOW}🔄 Updating package lists...${NC}"
$UPDATE_CMD

# Install essential build tools
echo -e "\n${YELLOW}🔨 Installing build tools and essentials...${NC}"
if [ "$PKG_MANAGER" = "apt" ]; then
    $INSTALL_CMD build-essential curl git wget
elif [ "$PKG_MANAGER" = "dnf" ]; then
    $INSTALL_CMD @development-tools curl git wget
fi

# Install Python development (interactive)
echo -e "\n${BLUE}🐍 Python Development Environment${NC}"
read -p "Install Python 3 + pip + venv? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}⏭️  Skipping Python installation${NC}"
    PYTHON_INSTALLED=false
else
    echo -e "${YELLOW}Installing Python development environment...${NC}"
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD python3 python3-pip python3-venv python3-dev
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        $INSTALL_CMD python3 python3-pip python3-devel
    fi
    PYTHON_INSTALLED=true
    echo -e "${GREEN}✅ Python installation completed${NC}"
fi

# Install Go (interactive)
echo -e "\n${BLUE}🐹 Go Programming Language${NC}"
read -p "Install Go (latest version)? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}⏭️  Skipping Go installation${NC}"
    GO_INSTALLED=false
else
    echo -e "${YELLOW}Installing Go programming language (latest version)...${NC}"
    bash <(curl -sL https://git.io/go-installer)
    GO_INSTALLED=true
    echo -e "${GREEN}✅ Go installation completed${NC}"
fi

# Install Node.js via NVM (interactive)
echo -e "\n${BLUE}🟢 Node.js Development Environment${NC}"
read -p "Install Node.js via NVM (latest LTS)? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}⏭️  Skipping Node.js installation${NC}"
    NODEJS_INSTALLED=false
else
    echo -e "${YELLOW}Installing Node.js via NVM...${NC}"
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        
        # Source NVM for this script
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        # Install latest LTS Node.js (v22)
        nvm install 22
        nvm use 22
        nvm alias default 22
        
        echo -e "${GREEN}✅ Node.js v22 LTS installed via NVM${NC}"
        NODEJS_INSTALLED=true
    else
        echo -e "${GREEN}✅ NVM already installed${NC}"
        NODEJS_INSTALLED=true
    fi
fi

# Install Rust (required for modern CLI tools)
echo -e "\n${BLUE}🦀 Rust Programming Language${NC}"
echo -e "${YELLOW}Installing Rust (required for modern CLI tools)...${NC}"
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # Source Rust environment for current session
    source ~/.cargo/env
    echo -e "${GREEN}✅ Rust installed successfully${NC}"
else
    echo -e "${GREEN}✅ Rust already installed${NC}"
fi

# Essential Python tools (conditional)
if [ "$PYTHON_INSTALLED" = true ]; then
    echo -e "\n${YELLOW}🔧 Installing essential Python tools...${NC}"
    pip3 install --user --upgrade pip setuptools wheel
    echo -e "${GREEN}✅ Python tools installation completed${NC}"
fi

# Create development directories
echo -e "\n${YELLOW}📁 Creating development directories...${NC}"
mkdir -p ~/Projects/{python,nodejs,go}
mkdir -p ~/go/{bin,src,pkg}
echo -e "${GREEN}✅ Development directories created${NC}"

echo
echo -e "${GREEN}✅ Essential development environment installation completed!${NC}"
echo
echo "📋 What was installed:"
echo "  • Build tools (gcc, make, etc.)"
echo "  • Git version control"
if [ "$PYTHON_INSTALLED" = true ]; then
    echo "  • Python 3 + pip + venv + essential packages"
fi
if [ "$GO_INSTALLED" = true ]; then
    echo "  • Go programming language"
fi
if [ "$NODEJS_INSTALLED" = true ]; then
    echo "  • Node.js (latest LTS via NVM)"
fi
echo "  • Rust programming language"
echo "  • Development project directories"
echo
echo "🔄 Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Verify installation: run the verification commands in DEVELOPMENT.md"
echo "  3. Install Java separately: cd java && ./install.sh"
echo "  4. Install optional tools: ./install-optional.sh"
echo
echo "💡 Note: If using ZSH, the environment paths are already configured."
echo "   If using Bash, you may need to add paths to ~/.bashrc"
