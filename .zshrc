# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

command -v brew >/dev/null && eval "$(brew shellenv)"

typeset -U fpath

# Prefer zsh's native Git completion over Homebrew Git's Bash wrapper. The
# native completion expands both short and long options from a single `-`.
if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
  for git_completion_dir in $fpath; do
    if [[ $git_completion_dir != "$HOMEBREW_PREFIX/share/zsh/site-functions" &&
          -r "$git_completion_dir/_git" ]]; then
      fpath=("$git_completion_dir" $fpath)
      break
    fi
  done
  unset git_completion_dir
fi

fpath=(
  "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-completions/src"
  $fpath
)

ZSH_THEME=""
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

plugins=(
  git
  fzf
  sudo
  copypath
  zsh-bat

  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
)

source $ZSH/oh-my-zsh.sh

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

# HISTORY
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# SHELL BEHAVIOR
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu no

zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' switch-group '<' '>'

# keybindings
alias cd="z"
