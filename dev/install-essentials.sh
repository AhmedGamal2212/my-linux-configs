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

# Install Python development (interactive)
echo "🐍 Python Development Environment"
read -p "Install Python 3 + pip + venv? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "⏭️  Skipping Python installation"
    PYTHON_INSTALLED=false
else
    echo "Installing Python development environment..."
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD python3 python3-pip python3-venv python3-dev
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        $INSTALL_CMD python3 python3-pip python3-devel
    fi
    PYTHON_INSTALLED=true
fi

# Install Go (interactive)
echo "🐹 Go Programming Language"
read -p "Install Go (latest version)? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "⏭️  Skipping Go installation"
    GO_INSTALLED=false
else
    echo "Installing Go programming language (latest version)..."
    bash <(curl -sL https://git.io/go-installer)
    GO_INSTALLED=true
fi

# Install Node.js via NVM (interactive)
echo "🟢 Node.js Development Environment"
read -p "Install Node.js via NVM (latest LTS)? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "⏭️  Skipping Node.js installation"
    NODEJS_INSTALLED=false
else
    echo "Installing Node.js via NVM..."
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
        NODEJS_INSTALLED=true
    else
        echo "✅ NVM already installed"
        NODEJS_INSTALLED=true
    fi
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

# Essential Python tools (conditional)
if [ "$PYTHON_INSTALLED" = true ]; then
    echo "🔧 Installing essential Python tools..."
    pip3 install --user --upgrade pip setuptools wheel
fi

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
