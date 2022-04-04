# Add GNU core utilities to beginning
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Add own Scripts
export PATH="$HOME/.dotfiles/bin:$PATH"


#Kubernetes Helper Configurations
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
#export KUBE_PS1_SYMBOL_USE_IMG=true
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(kubecontext context dir vcs newline)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator command_execution_time time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2


#Colorize Man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

#Magic Navigation Z Configurations
. $(brew --prefix)/etc/profile.d/z.sh

# Source iTerm2 Shell Integration
# https://iterm2.com/documentation-shell-integration.html
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval $(thefuck --alias)
eval "$(pyenv init -)"
