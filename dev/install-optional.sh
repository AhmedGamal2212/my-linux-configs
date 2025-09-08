#!/bin/bash
# Optional development tools installation script

set -e

echo "=== Optional Development Tools Setup ==="
echo "Installing additional development tools and utilities..."
echo

# Detect package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
else
    echo "❌ Unsupported package manager. This script supports apt (Ubuntu/Debian) and dnf (Fedora)."
    exit 1
fi

echo "📦 Using package manager: $PKG_MANAGER"
echo

# Function to install with error handling
install_package() {
    local package=$1
    local description=$2
    
    echo "📦 Installing $description ($package)..."
    if $INSTALL_CMD $package; then
        echo "✅ $description installed successfully"
    else
        echo "⚠️  Failed to install $description - may not be available in repositories"
    fi
    echo
}

# Database tools
echo "🗄️  Installing database tools..."
install_package "sqlite3" "SQLite database"

if [ "$PKG_MANAGER" = "apt" ]; then
    install_package "postgresql-client" "PostgreSQL client"
    install_package "mysql-client" "MySQL client"
elif [ "$PKG_MANAGER" = "dnf" ]; then
    install_package "postgresql" "PostgreSQL client"
    install_package "mysql" "MySQL client"
fi

# Network and API tools
echo "🌐 Installing network and API tools..."
install_package "httpie" "HTTPie (modern HTTP client)"
install_package "jq" "JSON processor"

if [ "$PKG_MANAGER" = "apt" ]; then
    install_package "net-tools" "Network utilities"
    install_package "nmap" "Network mapper"
elif [ "$PKG_MANAGER" = "dnf" ]; then
    install_package "net-tools" "Network utilities"
    install_package "nmap" "Network mapper"
fi

# System monitoring and utilities
echo "🖥️  Installing system utilities..."
install_package "htop" "Interactive process viewer"
install_package "tree" "Directory tree viewer"

# Optional eye candy
echo "🎨 Optional system information display"
read -p "Install neofetch (system info display)? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_package "neofetch" "System information tool"
else
    echo "⏭️  Skipping neofetch installation"
fi

# Archive tools
echo "📦 Installing archive utilities..."
if [ "$PKG_MANAGER" = "apt" ]; then
    install_package "unzip" "Unzip utility"
    install_package "p7zip-full" "7-Zip archive tool"
elif [ "$PKG_MANAGER" = "dnf" ]; then
    install_package "unzip" "Unzip utility"
    install_package "p7zip" "7-Zip archive tool"
fi

# Modern CLI alternatives (if available)
echo "⚡ Installing modern CLI tools..."
if [ "$PKG_MANAGER" = "apt" ]; then
    install_package "bat" "Modern cat alternative (syntax highlighting)"
    install_package "fd-find" "Modern find alternative"
    install_package "ripgrep" "Modern grep alternative"
elif [ "$PKG_MANAGER" = "dnf" ]; then
    install_package "bat" "Modern cat alternative"
    install_package "fd-find" "Modern find alternative"
    install_package "ripgrep" "Modern grep alternative"
fi

# Docker installation (optional, requires user confirmation)
echo "🐳 Docker Installation"
read -p "Do you want to install Docker? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing Docker..."
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        # Docker official installation script
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        
        # Add user to docker group
        sudo usermod -aG docker $USER
        echo "✅ Docker installed. Log out and back in to use docker without sudo."
        
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        $INSTALL_CMD docker docker-compose
        sudo systemctl enable --now docker
        sudo usermod -aG docker $USER
        echo "✅ Docker installed and enabled. Log out and back in to use docker without sudo."
    fi
else
    echo "⏭️  Skipping Docker installation"
fi

# Python development tools (user-level)
echo "🐍 Installing additional Python tools..."
echo "Installing Python development packages..."
pip3 install --user httpie black flake8 mypy 2>/dev/null || echo "⚠️  Some Python packages may not be available"

# Go development tools (if Go is installed)
if command -v go &> /dev/null; then
    echo "🐹 Installing Go development tools..."
    echo "Installing Go language server and debugger..."
    go install golang.org/x/tools/gopls@latest 2>/dev/null || echo "⚠️  Failed to install gopls"
    go install github.com/go-delve/delve/cmd/dlv@latest 2>/dev/null || echo "⚠️  Failed to install delve debugger"
else
    echo "⏭️  Go not found, skipping Go tools"
fi

echo
echo "✅ Optional development tools installation completed!"
echo
echo "📋 What was installed:"
echo "  • Database clients (SQLite, PostgreSQL, MySQL)"
echo "  • Network tools (HTTPie, jq, nmap, net-tools)"
echo "  • System utilities (htop, neofetch, tree)"
echo "  • Archive tools (unzip, 7zip)"
echo "  • Modern CLI alternatives (bat, fd, ripgrep)"
echo "  • Python development tools (black, flake8, mypy)"
echo "  • Go development tools (gopls, delve)"
if [[ $REPLY =~ ^[Yy]$ ]]; then
echo "  • Docker and Docker Compose"
fi
echo
echo "🔄 Next steps:"
echo "  • Restart terminal for new tools to be available"
echo "  • Test tools with verification commands in DEVELOPMENT.md"
if [[ $REPLY =~ ^[Yy]$ ]]; then
echo "  • Log out and back in to use Docker without sudo"
fi
echo "  • See MODERN-CLI-TOOLS.md for usage guides"
