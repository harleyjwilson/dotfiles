# Set up and load asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Environment variable declarations
export PATH="$PATH:/opt/homebrew/opt/gawk/libexec/gnubin"
export PATH="$PATH:/Users/harleywilson/.vscode-dotnet-sdk/.dotnet"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/Users/harleywilson/.local/bin"
export ZSH="$HOME/.oh-my-zsh"
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Stop tldr from auto updating
export TLDR_AUTO_UPDATE_DISABLED=true

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source powerlevel10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Update automatically without asking
zstyle ':omz:update' mode auto 

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(brew colorize gh git npm macos python z zsh-autosuggestions zsh-syntax-highlighting)

# Source oh-my-zsh.sh
source $ZSH/oh-my-zsh.sh

# Personal aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias gcc='gcc -Wall -ansi -pedantic'
alias cf='clang-format -style=file:/Users/harleywilson/dotfiles/.clang-format'
alias speedtest='speedtest --secure'
alias f='fuck'
alias rm='rm -r'
alias cp='cp -r'

# Set up 'thefuck'
eval $(thefuck --alias)
