#!/bin/bash

# 检测可用输出
HDMI=$(hyprctl monitors all | grep -o "HDMI-[A-Z0-9-]*" | head -n1)
DP=$(hyprctl monitors all | grep -o "DP-[A-Z0-9-]*" | head -n1)

if [ -n "$HDMI" ]; then
  hyprctl keyword monitor "$HDMI,2560x1440@280.00,auto,1.25"
  [ -n "$DP" ] && hyprctl keyword monitor "$DP,disable"
else
  [ -n "$DP" ] && hyprctl keyword monitor "$DP,2560x1440@260.00,auto,1.25"
fi
