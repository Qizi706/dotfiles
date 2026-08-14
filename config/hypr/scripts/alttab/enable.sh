#!/usr/bin/env bash
mkdir -p $XDG_RUNTIME_DIR/hypr/alttab
hyprctl -q eval 'hl.config({ animations = { enabled = false } }); alt_tab_down_bind:set_enabled(false); alt_tab_up_bind:set_enabled(false)'
footclient -a alttab $HOME/.config/hypr/scripts/alttab/alttab.sh $1

address=$(cat "$XDG_RUNTIME_DIR/hypr/alttab/address")
if [[ $address =~ ^0x[0-9a-fA-F]+$ ]]; then
  hyprctl -q dispatch "hl.dsp.focus({ window = \"address:$address\" })"
  hyprctl -q dispatch 'hl.dsp.window.alter_zorder({ mode = "top" })'
fi
