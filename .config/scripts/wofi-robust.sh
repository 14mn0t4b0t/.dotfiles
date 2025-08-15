#!/bin/bash

# Script robusto para lanzar wofi - resistente a problemas post-suspensión

# Configurar variables de entorno
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export GTK_THEME=Juno-ocean
export XCURSOR_THEME=miniature
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=qt5ct

# Verificar que WAYLAND_DISPLAY esté configurado
if [ -z "$WAYLAND_DISPLAY" ]; then
    export WAYLAND_DISPLAY="wayland-1"
fi

# Verificar que XDG_RUNTIME_DIR esté configurado
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
fi

# Matar instancias previas de wofi por si acaso
pkill wofi 2>/dev/null

# Esperar un momento para que se cierre completamente
sleep 0.2

# Lanzar wofi con las variables de entorno correctas
env QT_QPA_PLATFORMTHEME=qt5ct QT_STYLE_OVERRIDE=qt5ct GTK_THEME=Juno-ocean wofi --show drun
