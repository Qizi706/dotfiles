#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Prefer a Conda already available on PATH, then fall back to the personal
# Miniconda installation used on this machine. Keep this interactive-only so
# graphical sessions do not inherit a Conda-modified PATH.
__conda_executable="$(command -v conda 2>/dev/null || true)"
if [[ -z "$__conda_executable" && -x "$HOME/Programming/miniconda3/bin/conda" ]]; then
    __conda_executable="$HOME/Programming/miniconda3/bin/conda"
fi

if [[ -n "$__conda_executable" ]]; then
    __conda_setup="$("$__conda_executable" shell.bash hook 2>/dev/null)"
    if [[ $? -eq 0 ]]; then
        eval "$__conda_setup"
    elif [[ -f "$HOME/Programming/miniconda3/etc/profile.d/conda.sh" ]]; then
        . "$HOME/Programming/miniconda3/etc/profile.d/conda.sh"
    fi
fi
unset __conda_executable __conda_setup
