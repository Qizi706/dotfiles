# ~/.config/fish/profile.fish
# @author celeb zhou
# @since 2025
# general profile for fish shell

fish_add_path --global --prepend $HOME/.local/bin
fish_add_path --global --prepend $HOME/.local/sbin

if test -d /usr/share/neomutt/oauth2
    fish_add_path /usr/share/neomutt/oauth2
end

if test -x /usr/bin/bat
    set -gx MANROFFOPT -c
    set -gx MANPAGER "sh -c 'col -bx | bat --pager \"less -R\" -l man -p'"
end

# --------------------------
# 2. Basic Env (set -gx)
# --------------------------

# set -gx TERM xterm-256color
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"
set -gx EDITOR /usr/bin/nvim
set -gx PAGER /usr/bin/less

set -gx MOZ_USE_XINPUT2 1

set -gx BROWSER /usr/local/bin/firefox

# --------------------------
# 3. XDG Basic Catalog Env
# --------------------------

set -gx XDG_DOWNLOAD_DIR "$HOME/dls"
set -gx XDG_DOCUMENTS_DIR "$HOME/doc"
set -gx XDG_MUSIC_DIR "$HOME/mus"
set -gx XDG_PICTURES_DIR "$HOME/pic"
set -gx XDG_VIDEOS_DIR "$HOME/vid"
# set -gx FZF_DEFAULT_OPTS_FILE "$HOME/.config/fzf/fzfrc"

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# --------------------------
# 4. Other Application Env
# --------------------------

set -gx INPUTRC "$XDG_CONFIG_HOME/readline/inputrc"

set -gx CALCHISTFILE "$XDG_CACHE_HOME/calc_history"
set -gx CUDA_CACHE_PATH "$XDG_CACHE_HOME/nv"
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx W3M_DIR "$XDG_STATE_HOME/w3m"
set -gx WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"
set -gx ANDROID_SDK_HOME "$XDG_CONFIG_HOME/android"

# Rust/Go/Node/Python/NPM PATH
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GOMODCACHE "$XDG_CACHE_HOME/go/mod"
set -gx NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
set -gx PYTHON_HISTORY "$XDG_STATE_HOME/python_history"

# Java/Gradle
# set -gx _JAVA_OPTIONS "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
set -gx GRADLE_USER_HOME "$XDG_DATA_HOME"/gradle
set -gx GRIM_DEFAULT_DIR "$HOME/tmp"

# Agent/Socket
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
set -gx ABDUCO_SOCKET_DIR "$XDG_RUNTIME_DIR"

# --------------------------
# 5. Theme And Wayland Env
# --------------------------

# QT/GTK
set -gx QT_QPA_PLATFORMTHEME qt6ct
set -gx QT_QPA_PLATFORMTHEME_QT6 qt6ct
set -gx QT_STYLE_OVERRIDE adwaita-dark
set -gx GTK_THEME Adwaita-dark

# Wayland / Electron
set -gx WLR_DRM_NO_ATOMIC 1
set -gx ELECTRON_OZONE_PLATFORM_HINT wayland

# --------------------------
# 6. Input Method
# --------------------------

# Fcitx
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS @im=fcitx
set -gx SDL_IM_MODULE fcitx
set -gx GLFW_IM_MODULE ibus # GLFW IM MODULE
