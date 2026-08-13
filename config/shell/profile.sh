# User login/session environment for Bash and Zsh.
# Fish is the primary login shell; keep this fallback semantically aligned
# with profile.fish without adding shell-interactive initialization here.

[ "$(id -u)" -eq 0 ] || umask 027

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

export EDITOR=/usr/bin/nvim
export VISUAL="$EDITOR"
export PAGER=/usr/bin/less
export BROWSER=/usr/bin/firefox
export TERMINAL=ghostty

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export CALCHISTFILE="$XDG_CACHE_HOME/calc_history"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export W3M_DIR="$XDG_STATE_HOME/w3m"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export GRIM_DEFAULT_DIR="$HOME/tmp"

[ -f "$XDG_CONFIG_HOME/fzf/fzfrc" ] && export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME/fzf/fzfrc"
[ -f "$XDG_CONFIG_HOME/gtk-2.0/gtkrc" ] && export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

_profile_path_prepend() {
    [ -d "$1" ] || return
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}

_profile_path_append() {
    [ -d "$1" ] || return
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="${PATH:+$PATH:}$1" ;;
    esac
}

_profile_path_prepend "$CARGO_HOME/bin"
_profile_path_prepend "$HOME/.local/npm-global/bin"
_profile_path_prepend "$HOME/.local/sbin"
_profile_path_prepend "$HOME/.local/bin"
_profile_path_append /usr/lib/jvm/default/bin
_profile_path_append /usr/share/neomutt/oauth2

if [ -d /opt/cuda ]; then
    export CUDA_PATH=/opt/cuda
    _profile_path_append "$CUDA_PATH/bin"
    [ -x /usr/bin/g++-15 ] && export NVCC_CCBIN=/usr/bin/g++-15
fi
export PATH
unset -f _profile_path_prepend _profile_path_append

# Match /etc/profile.d/flatpak.sh for shells which do not source it.
: "${XDG_DATA_DIRS:=/usr/local/share:/usr/share}"
for _profile_data_dir in /var/lib/flatpak/exports/share "$HOME/.local/share/flatpak/exports/share"; do
    [ -d "$_profile_data_dir" ] || continue
    case ":$XDG_DATA_DIRS:" in
        *":$_profile_data_dir:"*) ;;
        *) XDG_DATA_DIRS="$_profile_data_dir:$XDG_DATA_DIRS" ;;
    esac
done
export XDG_DATA_DIRS
unset _profile_data_dir

if [ -x /usr/bin/bat ]; then
    export MANROFFOPT=-c
    export MANPAGER="sh -c 'col -bx | bat --pager \"less -R\" -l man -p'"
fi

export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt6ct
export ELECTRON_OZONE_PLATFORM_HINT=auto

export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export QT_IM_MODULES='wayland;fcitx;ibus'
export SDL_IM_MODULE=fcitx

if [ -n "${XDG_RUNTIME_DIR:-}" ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
    export ABDUCO_SOCKET_DIR="$XDG_RUNTIME_DIR"
fi
