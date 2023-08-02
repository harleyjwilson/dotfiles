#!/bin/zsh
source "${HOME}/.zshrc"

./storage.sh > storage.html

#qlmanage -p "storage.html"
open "storage.html"