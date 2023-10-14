#!/bin/sh

echo "Symlinking dotfiles..."

# Setting up directories
echo "Remove existing ~/.config/nvim/"
rm -rf ~/.config/nvim
echo "Remove existing ~/bin"
rm -rf ~/bin

# Symlink directories
echo "Linking ~/dotfiles/.config/nvim -> ~/.config/nvim"
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
echo "Linking ~/dotfiles/bin -> ~/bin"
ln -sf ~/dotfiles/bin ~/bin

# Symlink files
echo "Linking ~/dotfiles/.gitconfig -> ~/.gitconfig"
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
echo "Linking ~/dotfiles/.tool-versions -> ~/.tool-versions"
ln -sf ~/dotfiles/.tool-versions ~/.tool-versions
echo "Linking ~/dotfiles/.vimrc -> ~/.vimrc"
ln -sf ~/dotfiles/.vimrc ~/.vimrc
echo "Linking ~/dotfiles/.zshrc -> ~/.zshrc"
ln -sf ~/dotfiles/.zshrc ~/.zshrc
echo "Linking ~/dotfiles/Brewfile -> ~/Brewfile"
ln -sf ~/dotfiles/Brewfile ~/Brewfile

echo "Symlinking complete."
