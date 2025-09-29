# Copilot Instructions for Linux Configs Repository

## Project Architecture

This is a **modular Linux dotfiles repository** designed for interactive, selective installation of development environments. The key architectural principle is **dependency-aware, component-based installation** with comprehensive backup/restore capabilities.

### Core Design Pattern: Interactive Module Installation

-   **Master orchestrator**: `./install.sh` - Interactive script with color-coded prompts and dependency order
-   **Module pattern**: Each directory (`zsh/`, `vim/`, `dev/`, etc.) is a self-contained installation unit with `install.sh` + `README.md`
-   **Dependency order matters**: Fonts → Dev tools → Shell → Terminal → Editor → Optional tools

### Critical Workflow Commands

```bash
# Primary installation (interactive, handles dependencies)
./install.sh

# Backup before changes (essential for safe testing)
./testing/backup-current-config.sh

# Restore from backup
./testing/restore-config.sh ~/.config-backup-YYYYMMDD-HHMMSS

# Clean up test artifacts
./testing/clean-all.sh

# Fix common permission issues
./troubleshooting/fix-permissions.sh
```

## Development Conventions

### Script Structure Standards

1. **Color coding**: All scripts use consistent color variables (`GREEN`, `BLUE`, `YELLOW`, `RED`, `NC`)
2. **Error handling**: `set -e` at top, with graceful fallbacks
3. **Package manager detection**: Auto-detect `apt` vs `dnf` with conditional logic
4. **Interactive prompts**: Use `read -p "..." -n 1 -r` pattern with default to 'Y'
5. **Progress feedback**: Clear status messages with emojis and colored headers

### File Naming Patterns

-   `install.sh` - Module installer in each directory
-   `README.md` - Module documentation with usage examples
-   Main config files match tool names: `vimrc`, `zshrc`, `kitty.conf`
-   Testing utilities in `testing/` with descriptive names (`backup-current-config.sh`)

### Installation Script Requirements

Every module install script must:

-   Detect package manager (`apt` vs `dnf`)
-   Backup existing configs with `.backup` suffix
-   Handle permission issues gracefully
-   Provide clear success/failure messages
-   Support running multiple times safely (idempotent)

## Key Integration Points

### Backup/Restore System

-   **Comprehensive**: `testing/backup-current-config.sh` creates timestamped full backups
-   **Simple**: Individual scripts create `.backup` files
-   **Testing focus**: All backup utilities designed for safe experimentation

### Package Manager Abstraction

```bash
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
fi
```

### Modern CLI Tools Integration

-   Core modern replacements: `bat` (cat), `fd` (find), `rg` (grep), `eza` (ls)
-   All installed via Rust/Cargo in `dev/install-essentials.sh`
-   Documentation in `dev/MODERN-CLI-TOOLS.md` with usage examples

## Project-Specific Patterns

### Coffee-Themed Branding

-   Terminal prompts include coffee quotes and brewing animations
-   Author signature: "Created with ☕ by Ahmed Gamal (Gemmy)"
-   `coffee` alias for motivation in ZSH config

### Permission Management

-   Common issue: configs created as root
-   Solution pattern: `sudo chown -R $USER:$USER` for home directory files
-   Nuclear option available in `troubleshooting/fix-permissions.sh`

### Interactive Installation Philosophy

-   **Never force**: Always ask before installing optional components
-   **Clear descriptions**: Each module explains what it does before installation
-   **Dependency awareness**: Master installer enforces proper order
-   **Backup first**: Encourage comprehensive backup before major changes

## When Contributing

1. **Test with fresh systems**: Use `testing/test-fresh-install.sh` workflow
2. **Follow color conventions**: Import color variables from existing scripts
3. **Add proper documentation**: Every new module needs detailed README.md
4. **Support both package managers**: Test on Ubuntu/Debian and Fedora
5. **Make scripts idempotent**: Safe to run multiple times
6. **Add backup handling**: Create `.backup` files for existing configs

## Troubleshooting Integration

-   Centralized in `troubleshooting/TROUBLESHOOTING.md`
-   Permission fixes are most common issue
-   Package installation failures usually need `update` first
-   Font issues require `fc-cache -f`
