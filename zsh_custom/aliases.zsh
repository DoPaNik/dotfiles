# --------------------------------- ALIASES -----------------------------------
#alias ..='cd ..'
alias cp='cp -v'
alias rm='rm -I'
alias mv='mv -iv'
alias ln='ln -sriv'
alias xclip='xclip -selection c'
command -v vim > /dev/null && alias vi='vim'

### Colorize commands
alias ls='ls --color=auto'

### LS & TREE
alias ll='ls -la'
alias la='ls -A'
alias l='ls -F'
command -v lsd > /dev/null && alias ls='lsd --group-dirs first' && \
	alias tree='lsd --tree'
command -v colorls > /dev/null && alias ls='colorls --sd --gs' && \
	alias tree='colorls --tree'

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

alias nt="cd $HOME/Documents/Novatec"
alias bit="cd $HOME/Documents/BrainActivIT"
alias dopamin="cd $HOME/Documents/DOPAmin"
alias zshconfig="code $HOME/.zshrc"

alias pl="pulumi"

weather() { curl -4 wttr.in/${1:-stuttgart} }

alias kubeinfo="kubectl version --short && \
kubectl get componentstatus && \
kubectl get nodes && \
kubectl cluster-info"

alias asp="source ~/.azure_sp/sp" 

find() {
	if [ $# = 1 ]
	then
		command find . -iname "*$@*"
	else
		command find "$@"
	fi
}