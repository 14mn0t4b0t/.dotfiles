#!/bin/bash

# Script para reiniciar componentes después de la suspensión
# Creado para solucionar problemas de wallpaper, wofi y barra

# Esperar un poco para que el sistema esté completamente despierto
sleep 2

# Obtener el usuario actual y su display
export USER=$(whoami)
export HOME="/home/$USER"

# Configurar variables de entorno para Wayland
export WAYLAND_DISPLAY="wayland-1"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Variables para aplicaciones
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export GTK_THEME=Juno-ocean
export XCURSOR_THEME=miniature
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=qt5ct

# Log para debug
echo "$(date): Post-suspend script iniciado" >> /tmp/post-suspend.log

# Reiniciar swaybg (wallpaper)
if [ -f "$HOME/.cache/current_wallpaper" ]; then
    pkill -f swaybg
    sleep 1
    WALLPAPER=$(cat "$HOME/.cache/current_wallpaper")
    if [ -f "$WALLPAPER" ]; then
        swaybg -m fill -i "$WALLPAPER" &
        echo "$(date): Wallpaper reiniciado: $WALLPAPER" >> /tmp/post-suspend.log
    else
        echo "$(date): ERROR - Wallpaper no encontrado: $WALLPAPER" >> /tmp/post-suspend.log
    fi
else
    echo "$(date): ERROR - Archivo current_wallpaper no encontrado" >> /tmp/post-suspend.log
fi

# Reiniciar mako (notificaciones) si es necesario
if ! pgrep -f mako > /dev/null; then
    mako &
    echo "$(date): Mako reiniciado" >> /tmp/post-suspend.log
fi

# Verificar yambar y reiniciarlo si hay problemas
YAMBAR_PID=$(pgrep yambar)
if [ -z "$YAMBAR_PID" ]; then
    yambar &
    echo "$(date): Yambar reiniciado" >> /tmp/post-suspend.log
fi

# Configurar pantallas externas si están conectadas
sleep 1
wlr-randr --output HDMI-A-2 --below eDP-1 --transform 270 --off
echo "$(date): Pantallas configuradas" >> /tmp/post-suspend.log

# Verificar y reiniciar udiskie si es necesario
if ! pgrep -f udiskie > /dev/null; then
    udiskie &
    echo "$(date): Udiskie reiniciado" >> /tmp/post-suspend.log
fi

echo "$(date): Post-suspend script completado" >> /tmp/post-suspend.log
