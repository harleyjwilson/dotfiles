# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up and load nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Environment variable declarations
export PATH="$PATH:$HOME/.nvm/"
export PATH="$PATH:$HOME/.nvm/versions/node/v20.1.0/bin"
export PATH="$PATH:$HOME/.jenv/bin"
export PATH="$PATH:/opt/homebrew/bin/python3"
export PATH="$PATH:/usr/local/lib/ruby/gems/3.0.0/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/bin"
export ZSH="$HOME/.oh-my-zsh"
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Source powerlevel10k
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# Update automatically without asking
zstyle ':omz:update' mode auto 

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

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
plugins=(1password autoupdate brew colorize gh git npm macos python sdk vscode z zsh-autosuggestions zsh-syntax-highlighting)

# Source oh-my-zsh.sh
source $ZSH/oh-my-zsh.sh

# Personal aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias gcc='gcc -Wall -ansi -pedantic'
alias cf='clang-format -style=file:/Users/harleywilson/dotfiles/.clang-format'
alias python=/opt/homebrew/bin/python3
alias pip=/opt/homebrew/bin/pip3
alias speedtest='speedtest --secure'
alias ga='git add'
alias gc='git commit -m '
alias push=/Users/harleywilson/dotfiles/bin/,git-push
alias f='fuck'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Alias 'fuck' to 'thefuck'
eval $(thefuck --alias)

# Set up jenv
eval "$(jenv init -)"

# Set up Jabba
[ -s "/Users/harleywilson/.jabba/jabba.sh" ] && source "/Users/harleywilson/.jabba/jabba.sh"
