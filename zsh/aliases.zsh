# --------------------------------- ALIASES -----------------------------------
alias cp='cp -v'
alias rm='rm -I'
alias mv='mv -iv'
alias ln='ln -sriv'
command -v vim > /dev/null && alias vi='vim'

### Colorize commands
alias ls='ls --color=auto'

### LS & TREE
alias ll='ls -la'
alias la='ls -A'
alias l='ls -F'
command -v lsd > /dev/null && alias ls='lsd --group-dirs first' && \
	alias tree='lsd --tree'

### CAT & LESS
command -v bat > /dev/null && \
	alias bat='bat --theme=ansi' && \
	alias cat='bat --pager=never' && \
	alias less='bat'
# in debian the command is batcat
command -v batcat > /dev/null && \
	alias batcat='batcat --theme=ansi' && \
	alias cat='batcat --pager=never' && \
	alias less='batcat'

alias reload="exec ${SHELL} -l"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias c="clear"

alias bit="cd $HOME/Documents/business/BrainActivIT"
alias dopamin="cd $HOME/Documents/business/DOPAmin"
alias zshconfig="code $DOTFILES"

find() {
	if [ $# = 1 ]
	then
		command find . -iname "*$@*"
	else
		command find "$@"
	fi
}
