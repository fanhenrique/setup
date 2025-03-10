# Make parent directories as needed
alias mkdir="mkdir --parents --verbose"

# Depends on the installation of the batcat package
alias bat="batcat"

# Depends on the installation of the xclip package
alias xc="xclip -in -selection clipboard"   # Copy
alias xv="xclip -out -selection clipboard"  # Paste

# Depends on the installation of the exa package
alias ls="exa"

alias ll='ls -l'
alias la='ls -la'

alias ..="cd .."

alias update="sudo apt update"
alias upgrade="sudo apt upgrade"

alias hg="history | grep"

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias diff="diff --color='auto'"

alias filesize="du -sh * | sort -h"

alias weather="curl https://wttr.in/"
