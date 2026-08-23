export EDITOR="nvim"

alias ls='eza -l --icons'
alias la='eza -a --icons'
alias ll='eza -la --icons'
alias lo='ll --sort=modified'


alias nix-update='nix-channel --update && home-manager switch'
alias nvim-nix='nvim  ~/.config/home-manager'
alias cdnix='cd ~/.config/home-manager'
alias nix-clean='nix-collect-garbage -d'


# stuff that wont really change
alias ..="cd .."
alias ...='../..'
alias ....="cd ../.."
alias .....='../../..'
alias ......="cd ../../.."
alias .......='../../../..'
alias ........="cd ../../../.."
alias .........='../../../../..'
alias ...........='../../../../../..'
alias grep='grep --color=auto'
alias l='clear'

export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"

