waalias reload="exec ${SHELL} -l"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias c="clear"

alias nt="cd $HOME/Documents/Novatec"
alias bit="cd $HOME/Documents/BrainActivIT"
alias dopamin="cd $HOME/Documents/DOPAmin"
alias zshconfig="code $HOME/.zshrc"

weather() { curl -4 wttr.in/${1:-stuttgart} }
