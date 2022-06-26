#!/bin/sh

echo "Symlinking dotfiles..."

# Symlink directories
ln -sf ~/dotfiles/bin ~/bin
echo "Linking ~/dotfiles/bin -> ~/bin"

# Symlink files
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
echo "Linking ~/dotfiles/.gitconfig -> ~/.gitconfig"
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
echo "Linking ~/dotfiles/.tmux.conf -> ~/.tmux.conf"
ln -sf ~/dotfiles/.vimrc ~/.vimrc
echo "Linking ~/dotfiles/.vimrc -> ~/.vimrc"
ln -sf ~/dotfiles/.zshrc ~/.zshrc
echo "Linking ~/dotfiles/.zshrc -> ~/.zshrc"
ln -sf ~/dotfiles/Brewfile ~/Brewfile
echo "Linking ~/dotfiles/Brewfile -> ~/Brewfile"
ln -sf ~/dotfiles/init.vim ~/.config/nvim/init.vim
echo "Linking ~/dotfiles/init.vim -> ~/.config/nvim/init.vim"


echo "Symlinking complete."
