#!/bin/bash

# Definir opciones de distribución
layouts=("us" "latam")

# Detectar si estamos en Wayland o Xorg
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    MENU="wofi --dmenu"
    #SETXKBMAP="swaymsg input '*' xkb_layout"
    SETXKBMAP="riverctl keyboard-layout"
else
    MENU="rofi -dmenu -p 'Select keyboard layout:'"
    SETXKBMAP="setxkbmap"
fi

# Mostrar menú y capturar selección
layout=$(printf "%s\n" "${layouts[@]}" | $MENU)

# Si el usuario seleccionó una opción, cambiar el layout
if [[ -n "$layout" ]]; then
    $SETXKBMAP "$layout"
fi
