#!/bin/bash
# Essential development environment installation script

set -e

echo "=== Essential Development Environment Setup ==="
echo "Installing core development tools and programming languages..."
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

echo "📦 Detected package manager: $PKG_MANAGER"
echo

# Update package lists
echo "🔄 Updating package lists..."
$UPDATE_CMD

# Install essential build tools
echo "🔨 Installing build tools and essentials..."
if [ "$PKG_MANAGER" = "apt" ]; then
    $INSTALL_CMD build-essential curl git wget
elif [ "$PKG_MANAGER" = "dnf" ]; then
    $INSTALL_CMD @development-tools curl git wget
fi

# Install Python development
echo "🐍 Installing Python development environment..."
if [ "$PKG_MANAGER" = "apt" ]; then
    $INSTALL_CMD python3 python3-pip python3-venv python3-dev
elif [ "$PKG_MANAGER" = "dnf" ]; then
    $INSTALL_CMD python3 python3-pip python3-devel
fi

# Install Go (latest version via go-installer)
echo "🐹 Installing Go programming language (latest version)..."
bash <(curl -sL https://git.io/go-installer)

# Install Node.js via NVM (more flexible than package manager)
echo "🟢 Installing Node.js via NVM..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    
    # Source NVM for this script
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install latest LTS Node.js (v22)
    nvm install 22
    nvm use 22
    nvm alias default 22
    
    echo "✅ Node.js v22 LTS installed via NVM"
else
    echo "✅ NVM already installed"
fi

# Install Rust (required for modern CLI tools)
echo "🦀 Installing Rust programming language..."
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # Source Rust environment for current session
    source ~/.cargo/env
    echo "✅ Rust installed successfully"
else
    echo "✅ Rust already installed"
fi

# Essential Python tools (user-level)
echo "🔧 Installing essential Python tools..."
pip3 install --user --upgrade pip setuptools wheel

# Create development directories
echo "📁 Creating development directories..."
mkdir -p ~/Projects/{python,nodejs,go}
mkdir -p ~/go/{bin,src,pkg}

echo
echo "✅ Essential development environment installation completed!"
echo
echo "📋 What was installed:"
echo "  • Build tools (gcc, make, etc.)"
echo "  • Git version control"
echo "  • Python 3 + pip + venv"
echo "  • Go programming language"
echo "  • Node.js (latest LTS via NVM)"
echo "  • Rust programming language"
echo "  • Essential Python packages"
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
