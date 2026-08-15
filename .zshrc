# Interactive Zsh configuration. Login/session variables live in
# ~/.config/shell/profile.sh and are loaded by ~/.zprofile.

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
typeset -g ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

# Only enable third-party plugins that are actually installed. A fresh machine
# can therefore open Zsh before the optional bootstrap step is run.
plugins=(git)
for plugin in zsh-autosuggestions fast-syntax-highlighting fzf-tab; do
  [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]] && plugins+=("$plugin")
done
unset plugin

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

if [[ -r "$HOME/.local/bin/proxy_toggle.zsh" ]]; then
  source "$HOME/.local/bin/proxy_toggle.zsh"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  PROMPT='%n@%m %~ %# '
fi
