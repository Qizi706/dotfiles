# .profile
# @author celeb zhou
# @since 2025
# bash specific profile

[ -f "$HOME/.config/shell/profile.sh" ] && . "$HOME/.config/shell/profile.sh"

if [ -n "${BASH_VERSION:-}" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

[ -d "$XDG_STATE_HOME/bash" ] || mkdir -p "$XDG_STATE_HOME/bash"
export HISTFILE="$XDG_STATE_HOME/bash/history"
