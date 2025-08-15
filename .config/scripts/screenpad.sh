#!/bin/bash

# Opciones para Rofi
selected_option=$(echo -e "enable screenpad\ndisable screenpad" | wofi -dmenu -p "Screenpad: ")

if [ "$selected_option" == "enable screenpad" ]; then
    # Habilitar la pantalla Toshiba
    wlr-randr --output HDMI-A-2 --below eDP-1 --transform 270 --on

    #wlr-randr --output HDMI-A-2 --pos 0,1080 --transform 270 --on
    notify-send "Screenpad enable"
elif [ "$selected_option" == "disable screenpad" ]; then
    # Deshabilitar la pantalla Toshiba
    wlr-randr --output HDMI-A-2 --off
    notify-send "Screenpad disable"
fi

# mirror wl-mirror --fullscreen-output HDMI-A-2 eDP-1
