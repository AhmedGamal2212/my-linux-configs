# ZSH Configuration

Comprehensive ZSH setup with Oh My Zsh, development tools, and vim integration.

## Quick Setup

### Terminal Profile Theme (Ubuntu/Debian only - recommended first)
```bash
# Install enhanced terminal theme with custom fonts, icons, git support, autocomplete
# From https://github.com/pixegami/terminal-profile
curl -sL https://raw.githubusercontent.com/pixegami/terminal-profile/main/install_profile.sh | bash
```

### Automatic Installation
```bash
./install.sh
```

### Manual Installation
```bash
# Install ZSH
sudo apt install zsh curl git  # Ubuntu/Debian
sudo dnf install zsh curl git  # Fedora

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Copy configuration
cp zshrc ~/.zshrc

# Set as default shell
chsh -s $(which zsh)
```

## Key Features

- **Vi mode** for vim-like command line editing
- **Development aliases** for common tasks
- **Java version switching** between JDK 17 and 21
- **Enhanced history** with 10,000 commands
- **Smart completion** with case-insensitive matching
- **Syntax highlighting** and auto-suggestions

## Development Environment

### Java Version Switching
```bash
setJdk17    # Switch to Java 17
setJdk21    # Switch to Java 21
```

### Quick Aliases
| Alias | Command |
|-------|---------|
| `v` | `vim` |
| `ll` | `ls -la` |
| `gs` | `git status` |
| `py` | `python3` |
| `proj` | `cd ~/Projects` |

### Useful Functions
```bash
mkproject myapp     # Create new project with git repo
vf pattern         # Find and edit file with vim
grepf pattern      # Search for pattern in files
psg process        # Find running processes
```

## Requirements

- ZSH shell
- Oh My Zsh
- Git and curl

## Customization

Create local configuration files:
- `~/.zshrc.local` - General customizations
- `~/.zshrc.work` - Work-specific settings
- `~/.zshrc.paths` - Custom PATH additions

## Troubleshooting

**Vi mode not working:**
- Restart terminal or run `exec zsh`
- Check with `bindkey -L | grep vi`

**Plugins not loading:**
- Verify plugin directories exist
- Run `source ~/.zshrc` to reload
