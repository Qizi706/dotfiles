# Compatibility login/session environment for Fish. Zsh is the primary shell;
# keep this aligned with profile.sh for an explicit Fish fallback.

# Match the Bash/Zsh login profile: newly created private files are not
# readable by other local users. Directories remain traversable by the owner.
umask 027

# XDG base directories. User folders such as Downloads and Pictures belong in
# ~/.config/user-dirs.dirs and must not be overridden here.
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME "$HOME/.config"
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME "$HOME/.cache"
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME "$HOME/.local/share"
set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME "$HOME/.local/state"

# User preferences shared by shells and graphical applications.
set -gx EDITOR /usr/bin/nvim
set -gx VISUAL $EDITOR
set -gx PAGER /usr/bin/less
set -gx BROWSER /usr/bin/firefox
set -gx TERMINAL ghostty

# Tool and application data locations.
set -gx PARALLEL_HOME "$XDG_CONFIG_HOME/parallel"
set -gx CALCHISTFILE "$XDG_CACHE_HOME/calc_history"
set -gx CUDA_CACHE_PATH "$XDG_CACHE_HOME/nv"
set -gx W3M_DIR "$XDG_STATE_HOME/w3m"
set -gx ANDROID_SDK_HOME "$XDG_CONFIG_HOME/android"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GOMODCACHE "$XDG_CACHE_HOME/go/mod"
set -gx NODE_REPL_HISTORY "$XDG_STATE_HOME/node_repl_history"
set -gx PYTHON_HISTORY "$XDG_STATE_HOME/python_history"
set -gx GRADLE_USER_HOME "$XDG_DATA_HOME/gradle"
set -gx GRIM_DEFAULT_DIR "$HOME/Pictures/Screenshots"

if test -f "$XDG_CONFIG_HOME/readline/inputrc"
    set -gx INPUTRC "$XDG_CONFIG_HOME/readline/inputrc"
end

if test -f "$XDG_CONFIG_HOME/wget/wgetrc"
    set -gx WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"
end

if test -f "$XDG_CONFIG_HOME/npm/npmrc"
    set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
end

if test -f "$XDG_CONFIG_HOME/fzf/fzfrc"
    set -gx FZF_DEFAULT_OPTS_FILE "$XDG_CONFIG_HOME/fzf/fzfrc"
end

if test -f "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
end

# Define tool roots before constructing PATH. Use a non-universal PATH scope so
# this file, rather than persistent Fish state, remains authoritative.
if test -d /opt/cuda
    set -gx CUDA_PATH /opt/cuda
    if test -x /usr/bin/g++-15
        set -gx NVCC_CCBIN /usr/bin/g++-15
    end
end

fish_add_path --global --prepend \
    "$HOME/.local/bin" \
    "$HOME/.local/sbin" \
    "$HOME/.local/npm-global/bin" \
    "$CARGO_HOME/bin"

fish_add_path --global --append \
    /opt/cuda/bin \
    /usr/lib/jvm/default/bin \
    /usr/share/neomutt/oauth2

# Fish does not source /etc/profile.d/flatpak.sh, so provide the equivalent
# data search path for desktop files, icons, and other Flatpak exports.
set -l session_data_dirs
for data_dir in "$HOME/.local/share/flatpak/exports/share" /var/lib/flatpak/exports/share
    if test -d "$data_dir"
        contains -- "$data_dir" $session_data_dirs; or set --append session_data_dirs "$data_dir"
    end
end
if set -q XDG_DATA_DIRS
    for data_dir in (string split : -- $XDG_DATA_DIRS)
        test -n "$data_dir"; and not contains -- "$data_dir" $session_data_dirs; and set --append session_data_dirs "$data_dir"
    end
end
for data_dir in /usr/local/share /usr/share
    contains -- "$data_dir" $session_data_dirs; or set --append session_data_dirs "$data_dir"
end
set -gx XDG_DATA_DIRS (string join : $session_data_dirs)

if test -x /usr/bin/bat
    set -gx MANROFFOPT -c
    set -gx MANPAGER "sh -c 'col -bx | bat --pager \"less -R\" -l man -p'"
end

# Session-wide Wayland and toolkit policy. Compositors no longer duplicate
# these values in their own configuration.
set -gx QT_QPA_PLATFORM wayland
set -gx QT_QPA_PLATFORMTHEME qt6ct
set -gx ELECTRON_OZONE_PLATFORM_HINT auto

# Fcitx 5: keep XWayland/Qt/SDL compatibility while allowing GTK 3/4 to use
# Wayland text-input directly. Qt 6.7+ uses QT_IM_MODULES as a fallback list.
set -gx XMODIFIERS '@im=fcitx'
set -gx QT_IM_MODULE fcitx
set -gx QT_IM_MODULES 'wayland;fcitx;ibus'
set -gx SDL_IM_MODULE fcitx

# User services and applications use the systemd socket-activated SSH agent.
if set -q XDG_RUNTIME_DIR
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    set -gx ABDUCO_SOCKET_DIR "$XDG_RUNTIME_DIR"
end
