#!/bin/sh
xrdb -merge ~/.Xresources
xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --primary --mode 2560x1600 --rate 165 --pos 0x0 --rotate normal --output HDMI-0 --off
