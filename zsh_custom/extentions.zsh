# Add GNU core utilities to beginning
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Add own Scripts
export PATH="$HOME/.dotfiles/bin:$PATH"


#Kubernetes Helper Configurations
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

#Magic Navigation Z Configurations
. $(brew --prefix)/etc/profile.d/z.sh

# Source iTerm2 Shell Integration
# https://iterm2.com/documentation-shell-integration.html
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval $(thefuck --alias)
eval "$(pyenv init -)"
