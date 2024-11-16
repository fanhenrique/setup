# --parents     No error if existing, make parent directories as needed
# --verbose     Print a message for each created directory
alias mkdir="mkdir --parents --verbose"

# Depends on the installation of the batcat package
alias bat="batcat"

# Depends on the installation of the exa package
alias ls="exa"

# Depends on the installation of the xclip package
alias xc="xclip -selection clipboard"

# Depends on the installation of the redshift package
# Back to normal with:
#   redshift -x
alias redshift="redshift -O 5500 -m randr"

# The brightness.sh file is in this repository
alias brightness="~/repos/setup/brightness.sh"

alias update="sudo apt update && sudo apt upgrade"

alias hg="history | grep"

alias ..="cd .."

alias diff="diff --color='auto'"

alias filesize="du -sh * | sort -h"

alias weather="curl https://wttr.in/"