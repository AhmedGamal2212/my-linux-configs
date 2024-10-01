#!/bin/bash
# Java installation script for ZSH switcher compatibility

set -e

echo "=== Java Development Kit Setup ==="

# Function to detect system and install Java
install_java() {
    if command -v apt &> /dev/null; then
        echo "Installing Java on Ubuntu/Debian system..."
        sudo apt update
        sudo apt install -y openjdk-17-jdk openjdk-21-jdk
        
        # Verify Ubuntu/Debian paths
        JAVA_17_PATH="/usr/lib/jvm/java-17-openjdk-amd64"
        JAVA_21_PATH="/usr/lib/jvm/java-21-openjdk-amd64"
        
    elif command -v dnf &> /dev/null; then
        echo "Installing Java on Fedora system..."
        sudo dnf install -y java-17-openjdk-devel java-21-openjdk-devel
        
        # Fedora uses different paths
        JAVA_17_PATH="/usr/lib/jvm/java-17-openjdk"
        JAVA_21_PATH="/usr/lib/jvm/java-21-openjdk"
        
        # Create local config for Fedora paths
        echo "Creating ~/.zshrc.local with Fedora-specific Java paths..."
        cat >> ~/.zshrc.local << EOF
# Fedora Java paths (overrides zshrc defaults)
export JAVA_HOME_17=$JAVA_17_PATH
export JAVA_HOME_21=$JAVA_21_PATH
EOF
        
    else
        echo "Package manager not supported. Please install Java manually."
        exit 1
    fi
}

# Install Java
install_java

# Verify installations
echo "Verifying Java installations..."

if [ -d "$JAVA_17_PATH" ]; then
    echo "✓ Java 17 found at: $JAVA_17_PATH"
    $JAVA_17_PATH/bin/java -version 2>&1 | head -1
else
    echo "✗ Java 17 not found at expected path: $JAVA_17_PATH"
    echo "Available Java installations:"
    ls -la /usr/lib/jvm/ | grep java || echo "None found"
fi

if [ -d "$JAVA_21_PATH" ]; then
    echo "✓ Java 21 found at: $JAVA_21_PATH"
    $JAVA_21_PATH/bin/java -version 2>&1 | head -1
else
    echo "✗ Java 21 not found at expected path: $JAVA_21_PATH"
fi

# Test switcher functions if zshrc is already installed
if [ -f ~/.zshrc ] && grep -q "setJdk17" ~/.zshrc; then
    echo "Testing Java switcher functions..."
    
    # Source the zshrc in a subshell to test
    (
        source ~/.zshrc 2>/dev/null
        [ -f ~/.zshrc.local ] && source ~/.zshrc.local 2>/dev/null
        
        echo "Testing setJdk17..."
        setJdk17 2>/dev/null && echo "✓ Java 17 switcher works"
        
        echo "Testing setJdk21..."
        setJdk21 2>/dev/null && echo "✓ Java 21 switcher works"
    ) || echo "⚠ Install ZSH configuration first to test switcher functions"
else
    echo "⚠ ZSH configuration not found. Install it to use Java switcher functions."
fi

echo ""
echo "✓ Java installation completed!"
echo ""
echo "Usage after installing ZSH config:"
echo "  setJdk17    # Switch to Java 17"
echo "  setJdk21    # Switch to Java 21"
echo "  java -version   # Check current version"
echo ""
if command -v dnf &> /dev/null; then
    echo "Note: Fedora-specific paths have been added to ~/.zshrc.local"
fi
