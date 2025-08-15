#!/bin/bash

# Obtener salidas activas desde wlr-randr
outputs=$(wlr-randr | grep -E '^[a-zA-Z0-9\-]+ ' | awk '{print $1}')

if [ -z "$outputs" ]; then
    notify-send "wl-mirror" "not screens avaliable"
    exit 1
fi

# Seleccionar fuente (pantalla que se va a reflejar)
source=$(echo "$outputs" | wofi --dmenu --prompt "Screen to mirror:")
[ -z "$source" ] && exit

# Ejecutar wl-mirror
wl-mirror --fullscreen "$source"

