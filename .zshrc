# Primary interactive shell configuration. Login/session variables live in
# ~/.config/shell/profile.sh and are loaded by ~/.zprofile.

: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"

typeset -g HISTFILE="$XDG_STATE_HOME/zsh/history"
typeset -g HISTSIZE=50000
typeset -g SAVEHIST=50000
typeset -g ZSH_CACHE_DIR="$XDG_CACHE_HOME/oh-my-zsh"
typeset -g ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
mkdir -p -- "$ZSH_CACHE_DIR" "${ZSH_COMPDUMP:h}" "${HISTFILE:h}"

# Support both the upstream per-user clone and Arch's oh-my-zsh-git package.
if [[ -z ${ZSH:-} || ! -r "$ZSH/oh-my-zsh.sh" ]]; then
  for framework in "$HOME/.oh-my-zsh" /usr/share/oh-my-zsh; do
    if [[ -r "$framework/oh-my-zsh.sh" ]]; then
      typeset -g ZSH="$framework"
      break
    fi
  done
  unset framework
fi

typeset -g ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}"
typeset -g ZSH_THEME=''
zstyle ':omz:update' mode disabled

# fzf-tab must load after completion setup but before plugins which wrap ZLE.
# Missing optional plugins are skipped, so a fresh machine still opens Zsh.
plugins=(git uv)
[[ -o zle ]] && plugins+=(fzf)
for plugin in fzf-tab zsh-autosuggestions fast-syntax-highlighting; do
  [[ -r "$ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh" ]] && plugins+=("$plugin")
done
unset plugin

zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -lah --color=always -- $realpath'
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#707A8C'
typeset -g ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

if [[ -r ${ZSH:-}/oh-my-zsh.sh ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit -d "$ZSH_COMPDUMP"
  [[ -o zle ]] && (( $+commands[fzf] )) && source <(fzf --zsh)
fi

# Keep Fish-like history behavior while retaining Zsh's shared, timestamped
# history. Trivial navigation commands and leading-space commands stay private.
setopt hist_find_no_dups hist_ignore_all_dups hist_reduce_blanks hist_save_no_dups

_dotfiles_history_filter() {
  emulate -L zsh
  local line=${1%%$'\n'}
  [[ -z ${line//[[:space:]]/} || $line == [[:space:]]* ]] && return 1

  local -a words
  words=(${(z)line})
  [[ ${words[1]:-} == (cd|pwd|ls|l|ll|la|exit|clear|history) ]] && return 1
  return 0
}
autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory _dotfiles_history_filter

if [[ -r "$HOME/.local/bin/proxy_toggle.zsh" ]]; then
  source "$HOME/.local/bin/proxy_toggle.zsh"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# Make Conda available without paying for its shell hook on every terminal.
typeset -g _dotfiles_conda_executable=''
if (( $+commands[conda] )); then
  _dotfiles_conda_executable=$commands[conda]
elif [[ -x "$HOME/Programming/miniconda3/bin/conda" ]]; then
  _dotfiles_conda_executable="$HOME/Programming/miniconda3/bin/conda"
fi

if [[ -n $_dotfiles_conda_executable ]]; then
  conda() {
    local conda_hook
    if ! conda_hook="$("$_dotfiles_conda_executable" shell.zsh hook 2>/dev/null)"; then
      "$_dotfiles_conda_executable" "$@"
      return
    fi
    eval "$conda_hook"
    unset _dotfiles_conda_executable
    conda "$@"
  }
fi

git-count() {
  if (( $# < 1 )); then
    print -u2 'usage: git-count <commit_hash> [author-regex]'
    return 1
  fi

  local start_commit=$1
  local authors=${2:-${GIT_COUNT_AUTHORS:-}}
  [[ -n $authors ]] || authors=$(command git config user.email)
  if [[ -z $authors ]]; then
    print -u2 'git-count: pass author-regex, set GIT_COUNT_AUTHORS, or configure user.email'
    return 1
  fi

  setopt localoptions pipefail
  command git log "$start_commit..HEAD" -E --author="$authors" --pretty=tformat: --numstat |
    command awk -v authors="$authors" -v start="$start_commit" '
      { add += $1; subs += $2; loc += $1 - $2 }
      END {
        printf "---------------------------\n作者: %s\n起始提交: %s\n---------------------------\n新增行数: %s\n删除行数: %s\n净增行数: %s\n", authors, start, add, subs, loc
      }
    '
}

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  PROMPT='%n@%m %~ %# '
fi
