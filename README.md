# Dotfiles

**Dotfiles** is an ongoing collection of my Mac development setup and configurations files. It is sparse at the moment but no doubt it will update as I go. I'm writing this as prepare to update my Mac. Hopefully it will come in handy as I go.

## Checklist

### 1. Prepare OS

- Update OS X.
- Download and install the latest version of Xcode from the Mac App Store.

### 2. Install CLI

- Open Terminal and trigger Xcode Command Line Tools installation: `xcode-select --install`
    **Be sure to open Xcode and agree to the terms of use.**
- Install Homebrew `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Install OhMyZSH `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Download [`.brew-install.md`](/brew-install.md) and install Homebrew packages `brew install $(<brew-install.md)`

### 3. Update Dotfiles

- Load [`.zshrc`](/.zshrc) contents into `~/.zshrc`
- Load [`.vim`](/.vim/) contents into `~/.vim/` folder
- Load [`.vimrc`](/.vimrc) contents into `~/.vimrc`
- Load [`init.vim`](init.vim) contents into `~/.config/nvim` folder
- Load [`.gitconfig`](/.gitconfig) contents into the global `~/.gitconfig`

### 4. Secure Git(hub) Access

- [Generate an access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) for Terminal to auth your GitHub account when 2FA is enabled.

### 5. Install GUI Applications

- Download [`.brew-install-cask.md`](/brew-install-cask.md) and install Homebrew packages `brew install --cask $(<brew-install-cask.md)`
- You can delete the two brew install md files once your done `rm brew-install.md brew-install-cask.md`

6. ### Customize Things

- Change Caps Lock key to Escape key.
- Update trackpad speed to its fastest setting.
- Set Dock icons to small and make automatically hide

## Use This as Needed

Please feel free to fork this repo, or just copy-paste things you need, and make it your own. **Please be sure to change your `.gitconfig` name and email address though!**

## Acknowledgements

This README checklist to set up my new Mac was based on [mdo/config](https://github.com/mdo/config) repo, customised for my own needs.