#!/bin/bash


./packages.sh

mkdir -pv "$HOME"/repos

cd "$HOME"/repos/ || exit

git clone https://github.com/fanhenrique/translate-select-text.git



# Aliases
# See the instructions in README.md
cp .bash_aliases "$HOME"


# monitors.sh
cp "monitors.sh "$HOME"

echo "
if [ -f $HOME/monitors.sh ]; then
    . $HOME/monitors.sh
fi
" >> ~/.xsessionrc

