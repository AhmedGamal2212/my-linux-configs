# Kitty Terminal Configuration

High-performance terminal emulator configuration optimized for development workflows.

## Quick Setup

### Automatic Installation
```bash
./install.sh
```

### Manual Installation
```bash
# Install kitty
sudo apt install kitty         # Ubuntu/Debian
sudo dnf install kitty         # Fedora

# Copy configuration
mkdir -p ~/.config/kitty
cp kitty.conf ~/.config/kitty/kitty.conf
```

## Key Features

- **Fira Code font** with ligatures for better code readability
- **Dark theme** optimized for long coding sessions
- **GPU acceleration** for smooth performance
- **Tab and window management** with intuitive shortcuts
- **System clipboard integration** with copy-on-select

## Essential Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab |
| `Ctrl+Shift+Enter` | New window |
| `Ctrl+Shift+C/V` | Copy/paste |
| `Ctrl+Plus/Minus` | Increase/decrease font size |
| `Ctrl+Shift+F` | Search in scrollback |

## Requirements

- Kitty terminal emulator
- Fira Code font (install with `fonts/install.sh`)

## Customization

Create `~/.config/kitty/local.conf` for machine-specific settings:
```conf
# Example local customizations
font_size 16.0
background #000000
```

## Troubleshooting

**Font not displaying correctly:**
- Install Fira Code: Run `./install.sh` from the fonts directory  
- Update font cache: `fc-cache -f`

**Shortcuts not working:**
- Check for conflicting system shortcuts
- Verify kitty version supports the feature
