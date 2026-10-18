# ~/.zshrc — linked from ~/.dotfiles/home/.zshrc

# Path to my dotfiles
export DOTFILES=$HOME/.dotfiles

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set by `brew shellenv` in ~/.zprofile; fallback for non-login shells
: "${HOMEBREW_PREFIX:=/opt/homebrew}"

# The prompt comes from Starship (see ~/.config/starship.toml)
ZSH_THEME=""

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Every *.zsh file in here is sourced by Oh My Zsh (aliases, path, tools)
ZSH_CUSTOM=$DOTFILES/zsh

# Additional completions from Homebrew
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Add wisely, as too many plugins slow down shell startup.
# zsh-syntax-highlighting has to be the last one.
plugins=(
  git gh
  kubectl kubectx helm
  docker
  azure
  composer npm
  macos vscode
  fzf mise z
  starship
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Source iTerm2 Shell Integration
# https://iterm2.com/documentation-shell-integration.html
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Machine specific settings that do not belong in the repository
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
