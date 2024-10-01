# Linux Config Repository

## Overview
Clean, modular dotfiles for quick Linux development environment setup on Debian and Fedora distros.

## Repository Structure
```
my-linux-config/
├── README.md
├── dev/
│   ├── README.md
│   ├── MODERN-CLI-TOOLS.md
│   ├── install-essentials.sh
│   └── install-optional.sh
├── vim/
│   ├── vimrc
│   ├── install.sh
│   └── README.md
├── kitty/
│   ├── kitty.conf
│   ├── install.sh
│   └── README.md
├── zsh/
│   ├── zshrc
│   ├── install.sh
│   └── README.md
├── java/
│   ├── GUIDE.md
│   ├── install.sh
│   └── README.md
├── fonts/
│   ├── install.sh
│   └── README.md
└── troubleshooting/
    ├── TROUBLESHOOTING.md
    └── fix-permissions.sh
```

## Complete Setup Guide

### 1. System Preparation
```bash
# Fix any permission issues first (if needed)
./troubleshooting/fix-permissions.sh

# Make scripts executable
chmod +x */install.sh
```

### 2. Core Development Environment
```bash
# Install essential development tools first
# See dev/README.md for complete setup guide

# Ubuntu/Debian (Zorin OS)
sudo apt update && sudo apt install -y build-essential curl git wget

# Fedora
sudo dnf install -y @development-tools curl git wget
```

### 3. Terminal Profile Theme (Ubuntu/Debian only)
```bash
# Install enhanced terminal theme with custom fonts, icons, git support, autocomplete
# From https://github.com/pixegami/terminal-profile
curl -sL https://raw.githubusercontent.com/pixegami/terminal-profile/main/install_profile.sh | bash
```

### 4. Fonts and Terminal Setup
```bash
# Install fonts first (needed for terminal)
cd fonts && ./install.sh

# Install and configure terminal
cd kitty && ./install.sh
```

### 5. Shell and Editor
```bash
# Install shell (includes development aliases and Java switcher)
cd zsh && ./install.sh

# Install editor
cd vim && ./install.sh
```

### 6. Programming Languages and Tools
```bash
# See dev/README.md for detailed language setup:
# - Java (OpenJDK 17 & 21)
# - Python 3 + pip + venv
# - Node.js via NVM
# - Golang
# - Additional development tools
```

### 7. Optional Components
```bash
# Docker, databases, etc. (see dev/README.md)
```

## Quick Setup

### Individual Component Installation
```bash
# Install fonts first (recommended)
cd fonts && ./install.sh

# Install development tools (essential)
cd dev && ./install-essentials.sh

# Install java configuration
cd java && ./install.sh

# Install kitty terminal
cd kitty && ./install.sh

# Install vim configuration  
cd vim && ./install.sh

# Install zsh configuration
cd zsh && ./install.sh
```

### Manual Configuration (if scripts fail)
Each component directory contains clean config files that can be copied manually:

```bash
# Manual vim setup
cp vim/vimrc ~/.vimrc

# Manual kitty setup
mkdir -p ~/.config/kitty
cp kitty/kitty.conf ~/.config/kitty/kitty.conf

# Manual zsh setup
cp zsh/zshrc ~/.zshrc
```

## Features

### Vim Configuration
- Clean, minimal setup with essential development features
- System clipboard integration
- Vim motions and keyboard-centric workflow
- Smart search and navigation

### Kitty Terminal
- Fira Code font with ligatures
- Dark theme optimized for development
- Efficient keybindings for tab and window management
- Performance optimizations

### ZSH Shell
- Oh My Zsh with development-focused plugins
- Vi mode integration
- Java version switching (17/21)
- Development aliases and functions
- Enhanced history and completion

### Fonts
- Fira Code (primary) with JetBrains Mono backup
- Automatic installation and fallback handling

## Supported Systems
- Zorin OS (Ubuntu-based)
- Fedora KDE
- Other Debian/Ubuntu derivatives
- Other Red Hat derivatives

## Installation Scripts
- Automatic package manager detection (apt/dnf)
- Safe backup of existing configurations
- Error handling and verification
- Minimal dependencies and complexity

## Troubleshooting

### Permission Denied Errors
If install scripts fail with permission errors:

```bash
# Quick fix - make scripts executable
chmod +x */install.sh

# Fix config file permissions (if previously created as root)
sudo chown -R $USER:$USER ~/.vimrc ~/.vim/ ~/.config/ ~/.zshrc

# Run the fix-permissions script (nuclear option)
./troubleshooting/fix-permissions.sh
```

### Common Issues

- **Scripts not executable:** Run `chmod +x */install.sh`
- **Config files owned by root:** Run permission fix command above
- **Home directory permission issues:** Run `sudo chown -R $USER:$USER ~/`
