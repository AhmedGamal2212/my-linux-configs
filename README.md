# Linux Config Repository

## Overview
Clean, modular dotfiles for quick Linux development environment setup on Debian and Fedora distros.

## Repository Structure
```
my-linux-config/
├── README.md
├── install.sh          # 🚀 Interactive master installer
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

## Quick Setup

### 🚀 Interactive Installation (Recommended)
The easiest way to set up your development environment:

```bash
./install.sh
```

**Features:**
- **Interactive guidance** - Clear descriptions for each module
- **Selective installation** - Choose only what you need
- **Proper dependency order** - Automatically handles prerequisites
- **Colorful progress** - Visual feedback throughout the process
- **Safety checks** - Backs up existing configurations

**What you'll choose:**
1. **System preparation** (permissions, script setup)
2. **Fonts** (Fira Code, JetBrains Mono) 
3. **Development environment** (languages: Python, Node.js, Go - your choice)
4. **Terminal & shell** (ZSH + modern CLI tools)
5. **Terminal emulator** (Kitty - optional)
6. **Editor** (Vim configuration - optional)
7. **Java development** (OpenJDK 17 & 21 - optional)
8. **Additional tools** (databases, Docker, etc. - selective)

### ⚡ One-Command Setup
For a complete development environment with sensible defaults:
```bash
# Clone and run (press 'Y' for recommended modules)
git clone <repository-url>
cd my-linux-configs
./install.sh
```

## Manual Installation

### System Preparation
```bash
# Fix any permission issues first (if needed)
./troubleshooting/fix-permissions.sh

# Make scripts executable
chmod +x */install.sh

# Install system build tools (required for development)
# Ubuntu/Debian: sudo apt update && sudo apt install -y build-essential curl git wget
# Fedora: sudo dnf install -y @development-tools curl git wget
```

### Component Installation Order
Install components in the recommended order for best results:

```bash
# 1. Fonts (needed for terminal display)
cd fonts && ./install.sh

# 2. Development environment (see dev/README.md for details)
cd dev && ./install-essentials.sh
cd dev && ./install-optional.sh  # optional tools

# 3. Java development (see java/README.md for details)
cd java && ./install.sh

# 4. Terminal & shell
cd zsh && ./install.sh    # ZSH + modern CLI tools
cd kitty && ./install.sh  # terminal emulator (optional)

# 5. Editor
cd vim && ./install.sh    # vim configuration (optional)
```

### Manual Configuration Fallback
If installation scripts fail, manually copy configuration files:

```bash
# System preparation
cp vim/vimrc ~/.vimrc
mkdir -p ~/.config/kitty && cp kitty/kitty.conf ~/.config/kitty/
cp zsh/zshrc ~/.zshrc
```

### Ubuntu/Debian Terminal Theme (Optional)
Enhanced terminal theme with additional visual improvements:
```bash
# From https://github.com/pixegami/terminal-profile
curl -sL https://raw.githubusercontent.com/pixegami/terminal-profile/main/install_profile.sh | bash
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
- **☕ Coffee-Powered Features** - Because I can't let my caffeine addiction leave me anywhere I go, I've baked coffee into the terminal itself:
  - `coffee` alias for instant motivation brewing
  - Daily coffee quotes and programming wisdom
  - Coffee quotes on terminal startup
  - Brewing animations for those "compiling..." moments

### Fonts
- Fira Code (primary) with JetBrains Mono backup
- Automatic installation and fallback handling

## Supported Systems
- Ubuntu/Debian-based distributions (Ubuntu, Linux Mint, Pop!_OS, Elementary OS, etc.)
- Fedora and Red Hat-based distributions
- Other derivatives with apt or dnf package managers

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
