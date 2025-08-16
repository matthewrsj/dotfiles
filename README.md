# Dotfiles

My personal configuration files for macOS/Linux development environment.

## Features

- 🚀 **Neovim** - Modern config with LSP, Treesitter, and useful plugins
- 🐚 **Zsh** - Clean configuration with Oh My Zsh
- 🔧 **Language Support** - Go, Python, TypeScript, Rust, and more
- 🎨 **Syntax Highlighting** - Full Treesitter support for modern highlighting
- 🔍 **Code Navigation** - Jump to definition, find references, and more
- 🖱️ **Mouse Support** - Full mouse support in Neovim
- 🗂️ **Organized** - Secrets separated from public configs

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/matthewrsj/dotfiles.git ~/dotfiles
```

### 2. Install prerequisites

#### macOS
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install neovim git zsh ripgrep
```

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install neovim git zsh ripgrep
```

### 3. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 4. Create symlinks

```bash
# Backup existing configs
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup
[ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.backup
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup

# Create symlinks
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/bin ~/bin
```

### 5. Set up local configuration

```bash
# Copy the example file
cp ~/dotfiles/.zshrc.local.example ~/.zshrc.local

# Edit it to add your personal settings and secrets
vim ~/.zshrc.local

# Add your git user info
vim ~/.gitconfig.local
# Add:
# [user]
#     email = your.email@example.com
#     name = Your Name
```

### 6. Reload your shell

```bash
source ~/.zshrc
```

### 7. Open Neovim

The first time you open Neovim, it will automatically install all plugins and language servers:

```bash
nvim
```

Wait for the installation to complete (you'll see progress in the status line).

## Neovim Features

### Key Mappings

- `jj` - Exit insert mode (alternative to Esc)
- `Space` - Leader key

### Navigation
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show hover documentation
- `[d` / `]d` - Navigate diagnostics

### File Management
- `Space + ff` - Find files
- `Space + fg` - Live grep
- `Space + e` - File explorer

### Quick Reference

Type `vimhelp` or `nvimhelp` in your terminal to see the full cheat sheet.

## Customization

### Adding your own settings

1. **Machine-specific settings**: Add to `~/.zshrc.local`
2. **Neovim plugins**: Edit `~/dotfiles/.config/nvim/init.lua`
3. **Shell aliases**: Add to `~/dotfiles/.zshrc` (for public) or `~/.zshrc.local` (for private)

### Updating

```bash
cd ~/dotfiles
git pull
```

## Structure

```
dotfiles/
├── .config/
│   └── nvim/           # Neovim configuration
│       └── init.lua    # Main config file
├── bin/                # Personal scripts
│   └── nvim-cheat      # Neovim cheat sheet
├── .gitconfig          # Git configuration (without personal info)
├── .zshrc              # Zsh configuration (public)
├── .zshrc.local.example # Template for local settings
├── .bashrc.old         # Legacy bash config (archived)
├── i3/                 # i3 window manager config
└── README.md           # This file
```

## Troubleshooting

### Neovim plugins not loading

1. Open Neovim and run `:Lazy` to open the plugin manager
2. Press `U` to update plugins
3. Press `I` to install missing plugins

### Language servers not working

1. Open Neovim and run `:Mason`
2. Install the language server you need
3. Restart Neovim

### Treesitter highlighting not working

1. Open Neovim and run `:TSInstall <language>`
2. For example: `:TSInstall python`

## License

Feel free to use and modify these dotfiles as you like!
