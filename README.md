# Dotfiles

**Dotfiles** is an ongoing collection of my Mac development setup and configurations files. I have just updated it after moving to my new laptop, and included the use of Homebrew's Brewfile to install everything. I plan on developing a script to move the dotfiles to their relevant place.

## Checklist

### 1. Prepare OS

- Update OS X.
- Download and install the latest version of Xcode from the Mac App Store. **Open Xcode and agree to to the terms of use.**
- Download [dotfiles repo](https://github.com/harleyjwilson/dotfiles) to home directory.

### 2. Install Initial CLI

- Install OhMyZSH `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Install Homebrew `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`. This will install Xcode Command Line Tools, normally done by `xcode-select --install`, as a part of its normal setup process.

### 3. Set Up SSH Key for GitHub

- Follow the [connect to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/) instructions.

### 4. Install CLI & GUI Applications

- Copy the Brewfile in from the dotfiles repo to the home directory.
- Run `brew bundle`

### 5. Update Dotfiles

- Load [`.config/`](.config/) contents into `~/.config/` folder. This includes the kitty and nvim config files.
- Load [`.vim/`](/.vim/) contents into `~/.vim/` folder
- Load [`.zshrc`](/.zshrc) contents into `~/.zshrc`
- Load [`.vimrc`](/.vimrc) contents into `~/.vimrc`
- Load [`.gitconfig`](/.gitconfig) contents into the global `~/.gitconfig`

### 6. Customize Things

- Update trackpad speed to its fastest setting.
- Set Dock icons to small and make automatically hide

### 7. Clean Up

- Feel free to delete the repo once the setup is done `rm -rf dotfiles/`

## Use This as Needed

Please feel free to fork this repo, or just copy-paste things you need, and make it your own. **Please be sure to change your `.gitconfig` name and email address though!**

## Your Mileage May Vary (YMMV)

This is my personal setup checklist and may not work for your computer 😅

## Acknowledgements

This README checklist to set up my new Mac was based on [mdo/config](https://github.com/mdo/config) repo, customised for my own needs.
