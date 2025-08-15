#!/bin/bash

USER=$(whoami)
RUNTIME_DIR="/run/user/$(id -u $USER)"

# Mensaje de depuración
echo "USER: $USER"
echo "RUNTIME_DIR: $RUNTIME_DIR"
echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"

# Verificar si estamos en una sesión Wayland
if [ -z "$WAYLAND_DISPLAY" ]; then
  echo "No hay una sesión Wayland activa."
  exit 1
fi

# Verificar que el directorio de runtime exista
if [ ! -d "$RUNTIME_DIR" ]; then
  echo "No se encontró el directorio de runtime para el usuario $USER."
  exit 1
fi

export XDG_RUNTIME_DIR="$RUNTIME_DIR"
export WAYLAND_DISPLAY

# Ejecutar waylock
echo "Ejecutando waylock..."
env XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
    sudo -u "$USER" /usr/bin/waylock

