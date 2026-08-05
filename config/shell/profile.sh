# .config/shell/profile.sh
# @author celeb zhou
# @since 2025
# general profile for bash/zsh

[ "$UID" -eq 0 ] || umask 027 # dir/file:750/640

path_prepend() {
  [ -d "$1" ] || return
  case ":$PATH:" in
  *":$1:"*) ;;
  *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.local/sbin"

command -v bat >/dev/null && export MANROFFOPT="-c" && export MANPAGER="sh -c 'col -bx | bat --pager \"less -R\" -l man -p'"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8 # locale
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="/usr/bin/less"

export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Movies"
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/fzfrc"

export XDG_CONFIG_HOME="$HOME/.config"    # analogous to /etc
export XDG_CACHE_HOME="$HOME/.cache"      # analogous to /var/cache
export XDG_DATA_HOME="$HOME/.local/share" # analogous to /usr/share
export XDG_STATE_HOME="$HOME/.local/state"

export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GRIM_DEFAULT_DIR="$HOME/tmp"

export PATH=~/.local/npm-global/bin:$PATH
