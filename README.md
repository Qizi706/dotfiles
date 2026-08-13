# dotfiles

Personal Arch Linux configuration for Niri, Hyprland, Fish/Zsh/Bash, terminal
tools, Fcitx 5, and GTK/Qt themes.

## Install

Review `install.conf.yaml` first, then run:

```sh
git submodule update --init --recursive
./install
```

Dotbot creates links into `~/.config`. Application state, credentials, browser
profiles, caches, logs, generated plugin trees, and machine identity stores are
intentionally excluded.

## Validate compositor configuration

```sh
niri validate -c config/niri/config.kdl
Hyprland --verify-config -c config/hypr/hyprland.lua
```

The `main` branch was rebuilt as a sanitized root snapshot on 2026-08-14. Do
not merge or push any clone that still contains the pre-rewrite history.
