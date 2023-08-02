#!/bin/zsh
source "${HOME}/.zshrc"

./diagnostic.sh > diagnostic.html

#qlmanage -p "diagnostic.html"
open "diagnostic.html"
