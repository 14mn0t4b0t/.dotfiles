#!/bin/bash

# Crear archivo temporal para guardar el directorio
tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

# Ejecutar Yazi y capturar el directorio seleccionado
yazi "$@" --cwd-file="$tmp"

# Si Yazi escribió un nuevo directorio y es diferente al actual, cambiarlo
if cwd="$(command cat -- "$tmp" 2>/dev/null)" && 
   [ -n "$cwd" ] && 
   [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd" || exit
fi

# Eliminar el archivo temporal
rm -f -- "$tmp"

# Mantener la terminal abierta con una shell interactiva
exec bash -i
