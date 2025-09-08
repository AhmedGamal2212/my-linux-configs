#!/bin/bash
# Master installation script for Linux Config Repository
# Interactive setup with proper dependency order

set -e

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored headers
print_header() {
    echo -e "\n${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} $1"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}\n"
}

# Function to print module info
print_module_info() {
    echo -e "${CYAN}📋 Module: $1${NC}"
    echo -e "${YELLOW}$2${NC}"
    echo
}

# Function to ask for confirmation
ask_confirmation() {
    local module_name="$1"
    local description="$2"
    
    print_module_info "$module_name" "$description"
    read -p "$(echo -e ${GREEN}Continue with this module? [Y/n]:${NC} )" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}⏭️  Skipping $module_name${NC}"
        return 1
    fi
    return 0
}

print_header "🚀 Linux Development Environment Setup"
echo -e "${GREEN}Welcome to the interactive Linux development environment installer!${NC}"
echo -e "${CYAN}This will set up a modern, powerful development environment with:${NC}"
echo "  • Modern terminal (ZSH + Starship + modern CLI tools)"
echo "  • Development tools and programming languages"
echo "  • Clean configuration files (vim, kitty, etc.)"
echo "  • Optional components (Docker, databases, etc.)"
echo

echo -e "${YELLOW}⚠️  Important Notes:${NC}"
echo "  • Scripts will request sudo permissions when needed"
echo "  • You can skip any module you don't need"
echo "  • Installation follows proper dependency order"
echo "  • Existing configurations will be backed up"
echo

read -p "$(echo -e ${GREEN}Ready to begin? [Y/n]:${NC} )" -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${RED}Installation cancelled.${NC}"
    exit 0
fi

# Module 1: System Preparation and Permissions
if ask_confirmation "System Preparation" "Fix file permissions and make scripts executable.\nEssential for proper installation."; then
    print_header "🔧 System Preparation"
    echo "Making scripts executable..."
    chmod +x */install.sh troubleshooting/fix-permissions.sh
    
    if [ -f troubleshooting/fix-permissions.sh ]; then
        echo "Fixing any existing permission issues..."
        ./troubleshooting/fix-permissions.sh 2>/dev/null || true
    fi
    echo -e "${GREEN}✅ System preparation completed${NC}"
fi

# Module 2: Fonts (recommended before terminal)
if ask_confirmation "Fonts Installation" "Install Fira Code and JetBrains Mono fonts.\nRequired for proper terminal display and modern CLI tools."; then
    print_header "🔤 Installing Fonts"
    cd fonts && ./install.sh && cd ..
    echo -e "${GREEN}✅ Fonts installation completed${NC}"
fi

# Module 3: Development Environment
if ask_confirmation "Development Environment" "Install core development tools and programming languages.\nIncludes: build tools, git, Rust (required for modern CLI tools).\nOptional: Python, Node.js, Go (interactive selection)."; then
    print_header "🛠️  Development Environment Setup"
    cd dev && ./install-essentials.sh && cd ..
    echo -e "${GREEN}✅ Development environment completed${NC}"
fi

# Module 4: Terminal and Shell
if ask_confirmation "Terminal & Shell Setup" "Install and configure ZSH with Oh My Zsh, Starship prompt,\nand modern CLI tools (eza, bat, fd-find, ripgrep, tig, fzf).\nCreates a powerful, beautiful terminal experience."; then
    print_header "🐚 Terminal & Shell Setup"
    cd zsh && ./install.sh && cd ..
    echo -e "${GREEN}✅ Terminal & shell setup completed${NC}"
fi

# Module 5: Terminal Emulator
if ask_confirmation "Kitty Terminal" "Install and configure Kitty terminal emulator.\nModern GPU-accelerated terminal with great font rendering.\nOptional but recommended for best experience."; then
    print_header "🖥️  Terminal Emulator Setup"
    cd kitty && ./install.sh && cd ..
    echo -e "${GREEN}✅ Kitty terminal setup completed${NC}"
fi

# Module 6: Editor Configuration
if ask_confirmation "Vim Editor" "Install and configure Vim with development-friendly settings.\nClean, minimal setup with essential features.\nOptional if you use other editors."; then
    print_header "📝 Editor Configuration"
    cd vim && ./install.sh && cd ..
    echo -e "${GREEN}✅ Vim configuration completed${NC}"
fi

# Module 7: Java Development (optional)
if ask_confirmation "Java Development" "Install and configure Java development environment.\nIncludes OpenJDK 17 & 21 with version switching.\nOptional - only install if you need Java development."; then
    print_header "☕ Java Development Setup"
    cd java && ./install.sh && cd ..
    echo -e "${GREEN}✅ Java development setup completed${NC}"
fi

# Module 8: Optional Development Tools
if ask_confirmation "Optional Development Tools" "Install additional development tools:\n• Database clients (SQLite, PostgreSQL, MySQL)\n• Network tools (HTTPie, jq)\n• Archive utilities\n• Docker (optional)\n• Additional Python/Go tools"; then
    print_header "🔧 Optional Development Tools"
    cd dev && ./install-optional.sh && cd ..
    echo -e "${GREEN}✅ Optional tools installation completed${NC}"
fi

# Final summary
print_header "🎉 Installation Complete!"
echo -e "${GREEN}Your development environment has been successfully set up!${NC}"
echo
echo -e "${CYAN}🔄 Next Steps:${NC}"
echo "1. ${YELLOW}Restart your terminal${NC} or run: ${BLUE}exec zsh${NC}"
echo "2. ${YELLOW}Log out and back in${NC} if ZSH was set as default shell"
echo "3. ${YELLOW}Test your setup:${NC}"
echo "   • Run ${BLUE}starship --version${NC} to verify prompt"
echo "   • Try modern CLI tools: ${BLUE}bat, fd, rg, eza${NC}"
echo "   • Check programming languages: ${BLUE}python3 --version, go version, node --version${NC}"
echo
echo -e "${CYAN}📚 Resources:${NC}"
echo "• Modern CLI tools guide: ${BLUE}dev/MODERN-CLI-TOOLS.md${NC}"
echo "• ZSH features reference: ${BLUE}zsh/README.md${NC}"
echo "• Development setup: ${BLUE}dev/README.md${NC}"
echo "• Troubleshooting: ${BLUE}troubleshooting/TROUBLESHOOTING.md${NC}"
echo
echo -e "${PURPLE}Enjoy your new development environment! 🚀${NC}"
