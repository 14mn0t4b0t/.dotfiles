#!/bin/sh

echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"

wlr-randr --output HDMI-A-2 --below eDP-1 --transform 270 --on

pkill -SIGTERM swaybg
pkill -SIGTERM mako
pkill -SIGTERM udiskie

sleep 1 &&

#$HOME/.config/scripts/hotkeys.sh &



sleep 0.5 &&

# Establecer wallpaper de forma más robusta
if [ -f "$HOME/.cache/current_wallpaper" ]; then
    WALLPAPER=$(cat "$HOME/.cache/current_wallpaper")
    if [ -f "$WALLPAPER" ]; then
        swaybg -m fill -i "$WALLPAPER" &
    else
        # Si el wallpaper guardado no existe, usar uno por defecto
        DEFAULT_WALL="$HOME/Pictures/wallpapers/default.jpg"
        if [ -f "$DEFAULT_WALL" ]; then
            swaybg -m fill -i "$DEFAULT_WALL" &
        fi
    fi
fi

#swww-daemon &

udiskie &

#swww-daemon --format xrgb &

mako &


#pidof -q gpaste-daemon || setsid -f gpaste-client daemon >/dev/null 2>&1 &


sleep 1 && wlr-randr --output HDMI-A-2 --below eDP-1 --transform 270 --off
