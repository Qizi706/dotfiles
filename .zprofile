# .zprofile
# Portable Zsh login profile; personal identity belongs in host-local files.
# zsh specific profile

[ -f "${HOME}/.config/shell/profile.sh" ] && . "${HOME}/.config/shell/profile.sh"

[ -d "${XDG_CACHE_HOME}/zsh" ] || mkdir -p "${XDG_CACHE_HOME}/zsh"

[ -d "${XDG_STATE_HOME}/zsh" ] || mkdir -p "${XDG_STATE_HOME}/zsh"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
