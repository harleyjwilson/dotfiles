#!/bin/sh

echo "Symlinking dotfiles..."

# Setting up directories
echo "Remove and create new ~/.config/nvim/"
rm -rf ~/.config/nvim/
mkdir ~/.config/nvim/
echo "Remove existing ~/bin"
rm -rf ~/bin

# Symlink directories
echo "Linking ~/dotfiles/bin -> ~/bin"
ln -sf ~/dotfiles/bin ~/bin

# Symlink files
echo "Linking ~/dotfiles/.gitconfig -> ~/.gitconfig"
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
echo "Linking ~/dotfiles/.tmux.conf -> ~/.tmux.conf"
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
echo "Linking ~/dotfiles/.vimrc -> ~/.vimrc"
ln -sf ~/dotfiles/.vimrc ~/.vimrc
echo "Linking ~/dotfiles/.zshrc -> ~/.zshrc"
ln -sf ~/dotfiles/.zshrc ~/.zshrc
echo "Linking ~/dotfiles/Brewfile -> ~/Brewfile"
ln -sf ~/dotfiles/Brewfile ~/Brewfile
echo "Linking ~/dotfiles/init.vim -> ~/.config/nvim/init.vim"
ln -sf ~/dotfiles/init.vim ~/.config/nvim/init.vim

echo "Symlinking complete."
