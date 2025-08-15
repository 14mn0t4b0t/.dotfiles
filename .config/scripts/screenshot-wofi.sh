#!/bin/bash
#  ____                               _           _
# / ___|  ___ _ __ ___  ___ _ __  ___| |__   ___ | |_
# \___ \ / __| '__/ _ \/ _ \ '_ \/ __| '_ \ / _ \| __|
#  ___) | (__| | |  __/  __/ | | \__ \ | | | (_) | |_
# |____/ \___|_|  \___|\___|_| |_|___/_| |_|\___/ \__|
# -----------------------------------------------------

# Wayland

# Configuración de directorio y nombre del archivo
DIR="$HOME/Pictures/screenshots/"
mkdir -p "$DIR"
NAME="screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
FULLPATH="$DIR$NAME"
TMP_IMG="/tmp/screenshot.png"
grim "$TMP_IMG"

# Opciones del menú
option1="Preview"
option2="Area"
option3="Edit"
option4="Erase"

options="$option1\n$option2\n$option3\n$option4"

# Bucle para mostrar el menú hasta que el usuario elija salir
while true; do
    choice=$(echo -e "$options" | wofi --dmenu -p "Take Screenshot")

    case $choice in
        $option1)  # Previsualizar captura y volver al menú
            imv -f "$TMP_IMG" || notify-send "No screenshot found"
        ;;
        
#        $option2)  # Captura de área seleccionada
#    # Aplicar reglas de riverctl al inicio
#    riverctl rule-add app-id="imv" float
#    riverctl float-filter-add app-id="imv"
#    riverctl float-size 100% 100%
#
#    # Capturar el área seleccionada y abrir la imagen con imv
#    imv -f "$TMP_IMG" & grimshot save area "$TMP_IMG" &&
#    
#
#    # Notificación de que la captura se ha creado
#    notify-send "Screenshot created" "Mode: Selected area"
#
#    # Deshacer las reglas de riverctl al final
#    riverctl rule-remove app-id="imv"
#    riverctl float-filter-remove app-id="imv"
#    ;;

        $option2)  # Captura de área seleccionada
            imv -f "$TMP_IMG" & grimshot save area "$TMP_IMG" && pkill imv

            #notify-send "Screenshot created" "Mode: Selected area"
            
            #grimshot save area "$TMP_IMG"
        ;;

        $option3)  # Editar captura y volver al menú
            if [ -f "$TMP_IMG" ]; then
                swappy -f "$TMP_IMG" -o "$TMP_IMG" || notify-send "Edit cancelled"
            else
                notify-send "No screenshot to edit"
            fi
        ;;

        $option4)  # Borrar captura y salir
            rm -f "$TMP_IMG"
            notify-send "Screenshot deleted"
            exit 0
        ;;

        *)  # Si el usuario cierra Wofi, guardar la captura y salir
            mv "$TMP_IMG" "$FULLPATH"
            wl-copy < "$FULLPATH"
            imv -f "$FULLPATH" &&
            notify-send "Screenshot Saved" -i "$FULLPATH"
            exit 0
        ;;
    esac
done
