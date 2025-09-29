# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular Linux development environment configuration repository that provides clean, organized dotfiles and installation scripts for Debian/Ubuntu and Fedora-based distributions. The repository focuses on creating a modern terminal-based development environment with ZSH, modern CLI tools, and essential development tooling.

## Architecture & Structure

The repository follows a modular component-based architecture where each component is self-contained with its own:
- Configuration files (dotfiles)
- Installation script (`install.sh`)
- Documentation (`README.md`)
- Optional guides (`GUIDE.md`, `MODERN-CLI-TOOLS.md`)

**Core Components:**
- `install.sh` - Interactive master installer that orchestrates all modules
- `dev/` - Development environment setup (languages, tools, essential packages)
- `zsh/` - ZSH shell configuration with modern CLI tools and plugins
- `vim/` - Vim editor configuration
- `kitty/` - Kitty terminal emulator configuration
- `fonts/` - Font installation (Fira Code, JetBrains Mono)
- `java/` - Java development environment with version switching
- `testing/` - Testing framework for installation validation
- `troubleshooting/` - Common issue fixes and permission management

**Key Design Principles:**
- Interactive installation with user choice at each step
- Automatic package manager detection (apt/dnf)
- Safe backup mechanisms for existing configurations
- Proper dependency ordering (fonts → dev tools → shell → terminal → editor)
- Comprehensive testing and validation framework

## Common Commands

### Installation Commands
```bash
# Interactive master installation (recommended)
./install.sh

# Component-specific installations
cd <component> && ./install.sh

# Essential development environment only
cd dev && ./install-essentials.sh

# Optional development tools
cd dev && ./install-optional.sh
```

### Recent Fixes (2024)
The installation system includes several important fixes for fresh system installations:

**PATH Loading Issues**: Scripts now automatically reload shell environment after installing Rust and Go, ensuring dependent tools can be installed in the same session.

**Fedora Java Support**: Enhanced Java installation with proper alternatives system setup and cross-platform path detection.

**Hyprland Compatibility**: Master installer automatically detects Hyprland environment and uses safe script execution to avoid command injection issues.

### Testing & Validation
```bash
# Create comprehensive backup
./testing/backup-current-config.sh

# Test fresh installation simulation
./testing/test-fresh-install.sh

# Restore from backup
./testing/restore-config.sh ~/.config-backup-YYYYMMDD-HHMMSS

# Clean all testing artifacts
./testing/clean-all.sh
```

### Troubleshooting Commands
```bash
# Fix permission issues (most common problem)
./troubleshooting/fix-permissions.sh

# Make scripts executable
chmod +x */install.sh

# Fix config file ownership
sudo chown -R $USER:$USER ~/.vimrc ~/.vim/ ~/.config/ ~/.zshrc ~/.oh-my-zsh/
```

## Development Environment Features

### ZSH Configuration (`zsh/zshrc`)
- Oh My Zsh with essential plugins (git, syntax highlighting, autosuggestions)
- Starship prompt for fast, customizable shell prompt
- Vi mode with visual indicators
- Java version switching functions (`setJdk17`, `setJdk21`)
- Lazy-loaded NVM for Node.js development
- Go and Python development paths
- Modern CLI tool aliases and integrations
- Coffee-themed features and motivational quotes

### Modern CLI Tools Stack
The ZSH installation includes modern replacements for traditional Unix tools:
- `bat` (better cat with syntax highlighting)
- `fd` (better find with simple syntax)
- `ripgrep` (rg - faster grep)
- `eza` (better ls with colors and icons)
- `tig` (Git TUI)
- `fzf` (fuzzy finder)

### Programming Language Support
- **Java**: OpenJDK 17 & 21 with switching functions
- **Python**: Python 3 + pip + venv with user package support
- **Node.js**: NVM-based installation with lazy loading
- **Go**: Full Go development environment with GOPATH setup
- **Rust**: Installed as dependency for modern CLI tools

## File Organization Guidelines

### Configuration Files
- Configuration files are stored in component directories alongside their installation scripts
- Backup strategy: Original configs are moved to `.backup` extensions
- ZSH config includes comprehensive development environment setup
- All configs follow the existing project's approach of putting practical functionality first

### Installation Scripts
- Each component has a self-contained `install.sh` script
- Scripts detect package manager automatically (apt vs dnf)
- Interactive prompts for user choice where appropriate
- Comprehensive error handling and verification
- Color-coded output for better user experience

### Documentation Structure
- Each component includes focused README.md documentation
- Guides are practical and include verification commands
- Troubleshooting is centralized but component-specific issues are documented locally

## Testing Framework

The repository includes a comprehensive testing framework in `testing/`:
- **Backup/restore system**: Full configuration backup and restoration
- **Fresh install simulation**: Test installation on current system with cleanup
- **Docker testing**: Instructions for isolated container testing
- **New user testing**: Guidelines for testing with separate user accounts

### Testing Workflow
1. Backup current configuration
2. Run fresh install test or use isolated environment
3. Validate installation results
4. Restore original configuration
5. Clean up testing artifacts

## Development Patterns

### Script Structure
All installation scripts follow a consistent pattern:
1. Color code definitions for output
2. Package manager detection
3. Update package lists
4. Install core dependencies
5. Interactive user choices for optional components
6. Configuration file installation with backup
7. Verification and completion messages

### Error Handling
- Scripts use `set -e` for early termination on errors
- Permission issues are the most common problem - always check and fix
- Package manager compatibility is verified before proceeding
- User confirmation is required for potentially disruptive changes

### Integration Points
- ZSH configuration serves as the central integration point for all development tools
- Java version switching is implemented as ZSH functions
- Modern CLI tools are integrated via aliases and PATH modifications
- All development environments respect user-level installations over system-wide when possible