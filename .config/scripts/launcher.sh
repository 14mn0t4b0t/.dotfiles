#!/bin/bash

# Wayland or Xorg
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    wofi --show drun
else
    rofi -show drun
fi
