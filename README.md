# Dotfiles

**Dotfiles** is an ongoing collection of my Mac development setup and configurations files. It is sparse at the moment but no doubt it will update as I go. I'm writing this as prepare to update my Mac. Hopefully it will come in handy as I go.

## Checklist

### 1. Prepare OS

- Update OS X.
- Download and install the latest version of Xcode from the Mac App Store.

### 2. Install Initial CLI

- Open Terminal and trigger Xcode Command Line Tools installation: `xcode-select --install`
    **Be sure to open Xcode and agree to the terms of use.**
- Install Homebrew `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Install OhMyZSH `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Run `brew upgrade`

### 3. Secure Git(hub) Access

- [Generate an access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) for Terminal to auth your GitHub account when 2FA is enabled.
- While your at it clone the repo `git clone git@github.com:harleyjwilson/dotfiles.git`

### 4. Install CLI & GUI Applications

- Download [`.brew-apps.md`](/brew/brew-apps.md) and install Homebrew packages `brew install $(<brew-apps.md)`
- Download [`.brew-apps-cask.md`](/brew/brew-apps-cask.md) and install Homebrew packages `brew install --cask $(<brew-apps-cask.md)`
- Install 11ty for personal website `npm install -g @11ty/eleventy`

### 5. Update Dotfiles

- Load [`.config/`](.config/) contents into `~/.config/` folder. This includes the kitty and nvim config files.
- Load [`.vim/`](/.vim/) contents into `~/.vim/` folder
- Load [`.zshrc`](/.zshrc) contents into `~/.zshrc`
- Load [`.vimrc`](/.vimrc) contents into `~/.vimrc`
- Load [`.gitconfig`](/.gitconfig) contents into the global `~/.gitconfig`

### 6. Customize Things

- Change Caps Lock key to Escape key.
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