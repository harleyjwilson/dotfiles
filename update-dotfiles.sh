#!/bin/bash

# Don't forget to make the file executable `chmod a+x update-dotfiles.sh`

echo "Updating dotfiles..."
cp -Rv ~/.config/nvim ~/dotfiles/.config
cp -Rv ~/.config/kitty ~/dotfiles/.config
cp -Rv ~/.vim ~/dotfiles
cp -Rv ~/bin/update.sh ~/dotfiles/bin
cp -Rv ~/bin/upgrade.sh ~/dotfiles/bin
cp -v ~/.gitconfig ~/dotfiles
cp -v ~/.vimrc ~/dotfiles
cp -v ~/.zshrc ~/dotfiles
cp -v ~/Brewfile ~/dotfiles
find ~/dotfiles \( -name '.DS_Store' \) -delete