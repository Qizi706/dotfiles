#!/usr/bin/env bash
hyprctl -q eval 'hl.config({ animations = { enabled = true } }); alt_tab_down_bind:set_enabled(true); alt_tab_up_bind:set_enabled(true)'
