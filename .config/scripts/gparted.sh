#!/bin/bash

# Si no está el polkit agent corriendo, lanzarlo
pgrep -u "$USER" polkit-gnome-authentication-agent-1 >/dev/null || \
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Permitir que root abra ventanas
xhost +SI:localuser:root

# Ejecutar gparted como root
pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY gparted

# Revocar permiso
xhost -SI:localuser:root
