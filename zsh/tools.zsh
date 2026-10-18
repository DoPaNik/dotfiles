# GNU core utilities before the BSD ones
path=("$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" $path)

# Add own Scripts
[ -d "$DOTFILES/bin" ] && path=("$DOTFILES/bin" $path)

# Kubernetes plugins installed with krew
path=("${KREW_ROOT:-$HOME/.krew}/bin" $path)

typeset -U path

# Colorize Man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
