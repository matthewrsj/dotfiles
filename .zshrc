# Path to your oh-my-zsh installation (using $HOME for portability)
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# Source oh-my-zsh if it exists
[[ -f $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Path configuration
export PATH="$HOME/bin:$PATH"

# Go environment
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# npm global packages
export PATH="$HOME/.npm-global/bin:$PATH"

# Aliases

# Use neovim instead of vim
alias vim='nvim'
alias vi='nvim'

# Neovim cheat sheet
alias vimhelp='nvim-cheat'
alias nvimhelp='nvim-cheat'

# Common aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git aliases (additional to oh-my-zsh git plugin)
alias gs='git status'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Source local configuration if it exists
# This is where you can put machine-specific settings and secrets
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local