# .zprofile
# @author celeb zhou
# @since 2025
# zsh specific profile

[ -f "${HOME}/.config/shell/profile.sh" ] && . "${HOME}/.config/shell/profile.sh"

[ -d "${XDG_CACHE_HOME}/zsh" ] || mkdir -p "${XDG_CACHE_HOME}/zsh"

[ -d "${XDG_STATE_HOME}/zsh" ] || mkdir -p "${XDG_STATE_HOME}/zsh"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

export HISTORY_IGNORE="(cd|cd -|cd ..|pwd|ls|exit|)"
