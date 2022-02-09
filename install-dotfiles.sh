#!/bin/bash

# Don't forget to make the file executable `chmod a+x install-dotfiles.sh`

echo "Installing dotfiles..."
cp -Rv ~/dotfiles/.config ~
cp -Rv ~/dotfiles/.vim ~
cp -Rv ~/dotfiles/bin ~
cp -v ~/dotfiles/.gitconfig ~
cp -v ~/dotfiles/.vimrc ~
cp -v ~/dotfiles/.zshrc ~
cp -v ~/dotfiles/Brewfile ~
