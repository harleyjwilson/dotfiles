#!/bin/sh

echo "Symbolic linking of dotfiles..."

# Symlink directories
ln -sf ~/dotfiles/bin ~/bin

# Symlink files
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/Brewfile ~/Brewfile
