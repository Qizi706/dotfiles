#!/usr/bin/env zsh

set -eu

ZSH_DIR="$HOME/.oh-my-zsh"
CUSTOM_DIR="$ZSH_DIR/custom/plugins"

if [[ ! -d "$ZSH_DIR/.git" ]]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR"
fi

typeset -A plugin_repos=(
  fzf-tab                https://github.com/Aloxaf/fzf-tab
  zsh-autosuggestions
  https://github.com/zsh-users/zsh-autosuggestions
  zsh-bat                https://github.com/fdellwing/zsh-bat.git
  zsh-completions
  https://github.com/zsh-users/zsh-completions.git
  zsh-syntax-highlighting
  https://github.com/zsh-users/zsh-syntax-highlighting.git
)

for name repo in ${(kv)plugin_repos}; do
  target="$CUSTOM_DIR/$name"
  [[ -d "$target/.git" ]] || git clone "$repo" "$target"
done

