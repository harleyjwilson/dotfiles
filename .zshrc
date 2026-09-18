#!/bin/zsh
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                                                                            ║
# ║                        ______    ______    __  __                          ║
# ║                       /\___  \  /\  ___\  /\ \_\ \                         ║
# ║                       \/_/  /__ \ \___  \ \ \  __ \                        ║
# ║                         /\_____\ \/\_____\ \ \_\ \_\                       ║
# ║                         \/_____/  \/_____/  \/_/\/_/                       ║
# ║                                                                            ║
# ║   harleyjwilson.com * github.com/harleyjwilson * hello@harleyjwilson.com   ║
# ║                                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# zmodload zsh/zprof

[[ -o interactive ]] || return

unset LS_COLORS
unset LSCOLORS


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Basics                                                                     ║
# ╚════════════════════════════════════════════════════════════════════════════╝

export OS="${OSTYPE%%-*}"
SHORT_HOST="${HOST%%.*}"

function __is_available {
  local prog="$1" os="${2:-}"
  [[ -z "$os" || "$os" == "$OS" ]] \
  && builtin whence -w -- "$prog" >/dev/null 2>&1
}

function __private_directory() {
  local dir="$1"
  local -A info
  [[ -e "$dir" || -L "$dir" ]] || command mkdir -m 700 -p -- "$dir" || return
  [[ -d "$dir" && ! -L "$dir" && -O "$dir" ]] || return 1
  zmodload -F zsh/stat b:zstat || return
  zstat -H info -- "$dir" || return
  (( (info[mode] & 8#777) == 8#700 ))
}

function __owned_directory() {
  local dir="$1"
  local -A info
  [[ -d "$dir" ]] || command mkdir -p -- "$dir" || return
  [[ -d "$dir" && -O "$dir" ]] || return 1
  zmodload -F zsh/stat b:zstat || return
  zstat -H info -- "$dir" || return
  (( (info[mode] & 8#002) == 0 ))
}

function __replace_file() {
  if [[ -d "$2" ]]; then
    print -u2 -- "Destination is a directory: $2"
    return 1
  fi
  command mv -f -- "$1" "$2"
}


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Exports                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

export LANG="en_AU.UTF-8"
export LC_ALL="en_AU.UTF-8"

export PROJECTS_DIR="${HOME}/projects"
export MY_PROJECTS_DIR="${HOME}/projects/@hjw"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_DOWNLOAD_DIR="${HOME}/downloads"
export XDG_DESKTOP_DIR="${HOME}/desktop"
export XDG_TEMPLATES_DIR="${HOME}/"
export XDG_PUBLICSHARE_DIR="${HOME}/shared/public"
export XDG_DOCUMENTS_DIR="${HOME}/documents"
export XDG_MUSIC_DIR="${HOME}/music"
export XDG_PICTURES_DIR="${HOME}/photos"
export XDG_VIDEOS_DIR="${HOME}/videos"


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Ghostty                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

if [[ -n "$GHOSTTY_RESOURCES_DIR" && -r \
      "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]]
then
  builtin source \
    "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Tmux Magic (via SSH)                                                       ║
# ╚════════════════════════════════════════════════════════════════════════════╝

__is_available tmux \
&& [[ -t 0 && -t 1 ]] \
&& [ -n "${SSH_CONNECTION}" ] \
&& [ -z "${TMUX}" ] \
&& [ "${USER}" != "root" ] \
&& tmux new-session -A -s ssh && exit


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ General Config                                                             ║
# ╚════════════════════════════════════════════════════════════════════════════╝

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=600000
SAVEHIST=500000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY
setopt SHARE_HISTORY

# INFO: `EDITOR` check further down below
export EDITOR="vim"


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Programs & tools                                                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# SSH
export SSH_KEY_PATH="${HOME}/.ssh/id_ed25519"

# Firefox
#export GDK_BACKEND="wayland"
export MOZ_ENABLE_WAYLAND="1"
export MOZ_USE_XINPUT2="1"

# https://github.com/oz/tz/
export TZ_LIST="\
America/Los_Angeles,Las Vegas;\
Zulu;Europe/Amsterdam,Amsterdam;\
Asia/Karachi,Lahore;\
Australia/Perth,Perth;Australia/Melbourne,Melbourne;Australia/Sydney,Sydney;"


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ ${PATH}                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

typeset -U path PATH

# Ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# Go
export GOPATH="$HOME/.go"
path=(
  "/usr/local/go/bin"
  "$GOPATH/bin"
  "${path[@]}"
)
export GOTOOLCHAIN="local"


# Cargo (Rust)
if [[ -r "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
elif [[ -d "$HOME/.cargo/bin" ]]; then
  path=("$HOME/.cargo/bin" "${path[@]}")
fi

# pnpm
export PNPM_HOME='/home/hjw/.local/share/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# uv
if [[ -d "$HOME/.local/bin" ]]; then
  path=("$HOME/.local/bin" "${path[@]}")
fi


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Completions                                                                ║
# ╚════════════════════════════════════════════════════════════════════════════╝

autoload -Uz compaudit compinit zrecompile
zmodload -i zsh/complist
ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

() {
  local lockfd
  if __owned_directory "$ZSH_CACHE_DIR" && zmodload zsh/system; then
    : >> "$ZSH_COMPDUMP.lock"
    if zsystem flock -t 1 -f lockfd "$ZSH_COMPDUMP.lock"; then
      {
        compinit -i -d "$ZSH_COMPDUMP"
        if [[ -f "$ZSH_COMPDUMP" && ( ! -f "$ZSH_COMPDUMP.zwc" ||
              "$ZSH_COMPDUMP" -nt "$ZSH_COMPDUMP.zwc" ) ]]; then
          zrecompile -q -p "$ZSH_COMPDUMP" &&
            command rm -f -- "$ZSH_COMPDUMP.zwc.old"
        fi
      } always {
        zsystem flock -u "$lockfd"
      }
      return
    fi
  fi
  compinit -i -D -d /dev/null
}

WORDCHARS=''

unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/completions"
zstyle '*' single-ignored show


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Autosuggestions                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGESTIONS="${HOME}/.zsh/zsh-autosuggestions"
[[ -r "$ZSH_AUTOSUGGESTIONS/zsh-autosuggestions.zsh" ]] &&
  source "$ZSH_AUTOSUGGESTIONS/zsh-autosuggestions.zsh"


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Misc                                                                       ║
# ╚════════════════════════════════════════════════════════════════════════════╝

autoload -Uz is-at-least
setopt multios
setopt long_list_jobs
setopt interactivecomments


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ GPG                                                                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝

export GPG_TTY=$TTY

# Fix for passphrase prompt on the correct TTY
# https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dssh_002dsupport
function _gpg-agent_update-tty_preexec {
  __is_available gpg-connect-agent || return 0
  gpg-connect-agent updatestartuptty /bye &>/dev/null
  return 0
}
autoload -U add-zsh-hook
add-zsh-hook preexec _gpg-agent_update-tty_preexec


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Bindkeys                                                                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Use emacs key bindings
bindkey -e

bindkey '^f' forward-char
bindkey '^[f' forward-word
bindkey '^H' backward-kill-word

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Aliases                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# https://github.com/ajeetdsouza/zoxide
__is_available zoxide \
&& [ "${USER}" != "root" ] \
&& eval "$(zoxide init --cmd cd zsh)"

# https://github.com/sharkdp/bat
__is_available bat \
&& alias cat=bat

# https://github.com/eza-community/eza
__is_available eza \
&& alias ls='eza --icons --color=auto' \
&& alias l='eza --icons --color=auto -l --no-time' \
&& alias ll='eza --icons --color=auto -la' \
&& alias lll='eza --icons --color=auto -la --total-size'

# https://github.com/ClementTsang/bottom
__is_available btm \
&& alias top='btm'

# https://github.com/helix-editor/helix
__is_available hx \
&& alias vi=hx \
&& alias vim=hx \
&& alias nvim=hx \
&& alias helix=hx \
&& export EDITOR="hx"

# https://github.com/junegunn/fzf
__is_available fzf \
&& alias preview='fzf --preview="bat {} --color=always"'

# https://github.com/nerdypepper/eva
__is_available eva \
&& alias calc='eva'

# https://github.com/imsnif/bandwhich
(( $+commands[bandwhich] )) \
&& alias bandwhich="sudo ${(q)commands[bandwhich]}"

# https://github.com/orf/gping
__is_available gping \
&& alias ping='gping'

# https://github.com/dalance/procs
__is_available procs \
&& alias ps='procs'

# https://github.com/dduan/tre
__is_available tre \
&& alias tree='tre'

# https://github.com/abishekvashok/cmatrix
__is_available cmatrix \
&& alias matrix='cmatrix -ba'

# Misc.
alias rmrf='rm -rf'
alias ehco=echo

alias my-ip="curl http://ipecho.net/plain; echo"


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Mosh/SSH wrapper                                                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# https://マリウス.com/automatically-upgrade-ssh-connections-to-mosh-when-available/
function __mosh_host() {
  emulate -L zsh
  local host="${(L)1}" config="$2" line previous=''
  [[ -r "$config" ]] || return 1
  while IFS= read -r line || [[ -n "$line" ]]; do
    line=${(L)line}
    [[ "$previous" == \#*features:*mosh* && "$line" == "host $host"* ]] &&
      return 0
    previous=$line
  done < "$config"
  return 1
}

function ssh {
  if (( $# == 1 )) && [[ -n "$1" && "$1" != -* ]] &&
      __is_available mosh && __mosh_host "${1##*@}" "$HOME/.ssh/config"; then
    print -u2 -- 'connecting with mosh ...'
    command mosh "$1"
  else
    print -u2 -- 'connecting with ssh ...'
    local term="$TERM"
    [[ "$term" != xterm-ghostty ]] || term=xterm-256color
    TERM="$term" command ssh "$@"
  fi
}


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ System Updates                                                             ║
# ╚════════════════════════════════════════════════════════════════════════════╝



function __require_commands() {
  local program result=0
  for program in "$@"; do
    if ! __is_available "$program"; then
      print -u2 -- "Required command is unavailable: $program"
      result=1
    fi
  done
  return "$result"
}

function __go_tool_paths() {
  local bin info line
  local -a fields
  local -aU packages
  for bin in "${GOPATH:-$HOME/.go}"/bin/*(N-.); do
    info=$(go version -m "$bin") || return
    for line in "${(@f)info}"; do
      fields=("${(@z)line}")
      if [[ "$fields[1]" == path && "$fields[2]" == github.com/* ]]; then
        packages+=("$fields[2]")
      fi
    done
  done
  (( $#packages )) && print -rl -- "${(@o)packages}"
  return 0
}

function update-tools() {
  __require_commands cargo cargo-install-update gh git go pnpm tldr uv || return
  local go_packages package
  go_packages=$(__go_tool_paths) || return

  printf "Updating Rust tools ...\n"
  cargo install-update -a -g || return

  printf "\nUpdating Go tools ...\n"
  unset GOPROXY
  for package in "${(@f)go_packages}"; do
    [[ -n "$package" ]] || continue
    go install "$package@latest" || return
  done

  printf '\nUpdating uv tools ...\n'
  uv tool upgrade --all

  printf '\nUpdating pnpm tools ...\n'
  pnpm update --global || return

  printf "\nUpdating tealdeer ...\n"
  tldr --update || return

  printf "\nUpdating Zsh plugins ...\n"
  if [[ -d "$HOME/.zsh/zsh-autosuggestions/.git" ]]; then
    git -C "$HOME/.zsh/zsh-autosuggestions" pull --ff-only || return
  fi

  printf '\nTools update complete\n'
}

function update-packages() {
  __require_commands dnf || return

  printf 'Updating packages ...\n'
  command sudo dnf update "$@"

  printf '\nUpdating flatpaks ...\n'
  command flatpak update

  printf '\nPackages update complete\n'
}

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Git                                                                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝

function __git_prompt_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

alias ga='git add'
alias ga.='ga .'
alias gb='git branch'

alias gc='git commit --verbose'
alias 'gc!'='git commit --verbose --amend'

alias glg='git log --oneline'

alias gd='git diff'
alias gds='git diff --staged'

alias gf='git fetch'

alias gl='git pull'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'

alias gm='git merge'

alias gp='git push'

alias gst='git status --short --branch'

alias gstl='git stash list'
alias gstaa='git stash apply'
alias gstp='git stash pop'
alias gstd='git stash drop'

alias gsw='git switch'


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Multimedia                                                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝

function rip() {
  if (( $# != 1 )) || [[ -z "$1" ]]; then
    print -u2 -- 'usage: rip <URL>'
    return 1
  fi
  yt-dlp \
    -f bestaudio \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --yes-playlist \
    --add-metadata \
    "$1"
}

function listen() {
  local url="$1"
  if [ "$1" = "to" ]
  then
    url="$2"
  fi
  [[ -n "$url" ]] || { print -u2 -- 'usage: listen [to] <URL>'; return 1; }

  mpv \
    --quiet \
    --no-video \
    "$url"
}


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ File Navigation                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh
lfcd () {
  cd "$(command lf -print-last-dir "$@")"
}


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Dotfile Management                                                         ║
# ╚════════════════════════════════════════════════════════════════════════════╝

export DOTFILES="${MY_PROJECTS_DIR}/dotfiles"

function __dotfiles_repository() {
  local root
  [[ "$DOTFILES" == /* && "${DOTFILES:A}" != / &&
     "${DOTFILES:A}" != "${HOME:A}" ]] || return 1
  root=$(git -C "$DOTFILES" rev-parse --show-toplevel) || return
  [[ "${root:A}" == "${DOTFILES:A}" && -r "$DOTFILES/.include" ]] || return 1
}

function dotfiles-update-remote() (
  __require_commands cargo cp dnf flatpak gh git go mkdir mktemp mv pnpm rpm rsync uv || return
  __dotfiles_repository \
  || { print -u2 -- 'Invalid dotfiles repository or include file!'; return 1; }
  local repo_status file stage
  local -a inventories=(dnf_repoquery_--userinstalled
    flatpak_list_--app_--columns_application_branch_origin cargo_install_--list
    pnpm_list_-g_--depth_0 go_list_github-com uv_tool_list)
  repo_status=$(git -C "$DOTFILES" status --porcelain) || return
  if [[ -n "$repo_status" ]]; then
    print -u2 -- 'Commit or stash existing dotfiles changes before exporting!'
    return 1
  fi
  for file in .profile .zshrc .wallpaper; do
    [[ -r "$HOME/$file" ]] \
    || { print -u2 -- "Missing source: $HOME/$file"; return 1; }
  done
  [[ -d "$XDG_CONFIG_HOME" && -d /usr/local ]] || return 1
  for file in .profile .zshrc .wallpaper .config \
      usr usr/local usr/local/bin "${inventories[@]}"; do
    [[ ! -L "$DOTFILES/$file" ]] || return 1
  done

  stage=$(mktemp -d "$DOTFILES/.dotfiles-export.XXXXXX") || return
  trap 'command rm -f -- "${stage}/${^inventories[@]}"
    command rmdir -- "$stage"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  trap 'exit 129' HUP
  dnf repoquery --userinstalled > "$stage/dnf_repoquery_--userinstalled" || return
  flatpak list --app --columns=application,branch,origin \
    > "$stage/flatpak_list_--app_--columns_application_branch_origin" || return
  cargo install --list > "$stage/cargo_install_--list" || return
  pnpm list -g --depth=0 > "$stage/pnpm_list_-g_--depth_0" || return
  __go_tool_paths > "$stage/go_list_github-com" || return
  uv tool list > "$stage/uv_tool_list" || return

  for file in .profile .zshrc .wallpaper; do
    command cp -- "$HOME/$file" "$DOTFILES/$file" || return
  done
  command mkdir -p -- "$DOTFILES/.config" \
    "$DOTFILES/usr/local/bin" || return
  rsync -avH --include-from="$DOTFILES/.include" \
    "$XDG_CONFIG_HOME/" "$DOTFILES/.config/" --delete-before || return
  rsync -avH --include-from="$DOTFILES/.include" \
    /usr/local/ "$DOTFILES/usr/local/" --delete || return
  for file in "${inventories[@]}"; do
    __replace_file "$stage/$file" "$DOTFILES/$file" || return
  done
)

function dotfiles-update-local() (
  __require_commands cp git mkdir rsync || return
  __dotfiles_repository \
  || { print -u2 -- 'Invalid dotfiles repository or include file!'; return 1; }
  local confirmation file
  local -a binaries=("$DOTFILES"/usr/local/bin/*(N.))
  integer install_binaries=1
  for file in .profile .zshrc .wallpaper .config; do
    [[ -r "$DOTFILES/$file" ]] \
      || { print -u2 -- "Missing source: $DOTFILES/$file"; return 1; }
  done
  [[ "$XDG_CONFIG_HOME" == /* && "$XDG_CONFIG_HOME" != / && -w "$HOME" ]] \
    || return 1
  if (( $#binaries )) && [[ ! -w /usr/local/bin ]]; then
    print -u2 -- '/usr/local/bin is not writable, skipping binaries!'
    install_binaries=0
  fi
  read -r 'confirmation?Apply dotfiles to this machine? [y/N] ' || return 1
  [[ "$confirmation" == [yY] || "$confirmation" == [yY][eE][sS] ]] || return 1

  for file in .profile .zshrc .wallpaper; do
    command cp -- "$DOTFILES/$file" "$HOME/$file" || return
  done
  rsync -avH --include-from="$DOTFILES/.include" \
    "$DOTFILES/.config/" "$XDG_CONFIG_HOME/" || return
  if (( install_binaries && $#binaries )); then
    command cp -- "${binaries[@]}" /usr/local/bin/ || return
  fi
  return 0
)


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Prompt                                                                     ║
# ╚════════════════════════════════════════════════════════════════════════════╝

__is_available starship \
&& eval "$(starship init zsh)"


# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Stuff other programs dare to append goes here                              ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# ...

# zprof
