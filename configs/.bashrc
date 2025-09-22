# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$HOME/bin:$PATH"

alias cl='clear'

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

PS1='[\u@\h \W]\$ '
