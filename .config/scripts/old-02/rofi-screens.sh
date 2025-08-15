#!/bin/bash

# Variables para almacenar las pantallas seleccionadas
screen1=""
screen2=""
resolutiontem=""

# Función para mostrar el menú de rofi para seleccionar el modo
show_mode_menu() {
    local mode_list=("Dual" "Mirror")
    local mode=$(printf '%s\n' "${mode_list[@]}" | rofi -dmenu -p "Mode:")
    
    if [ "$mode" = "Dual" ]; then
        select_dual_mode
    elif [ "$mode" = "Mirror" ]; then
        select_mirror_mode
    else
        echo "Selected Mode: $mode"
    fi
}

# Función para seleccionar monitores en modo Dual
select_dual_mode() {
    # Seleccionar el primer monitor
    screen1=$(show_available_menu "Select Screen 1")
    echo "Screen 1: $screen1"
    
    # Seleccionar el segundo monitor
    screen2=$(show_available_menu "Select Screen 2")
    echo "Screen 2: $screen2"

    # Obtener resolución actual de screen2
    resolutiontem=$(xrandr | awk -v monitor="$screen2" '
        $0 ~ monitor && / connected/ {
            match($0, /[0-9]+x[0-9]+/)
            if (RSTART) print substr($0, RSTART, RLENGTH)
        }
    ')

    # Seleccionar la posición de screen2 con respecto a screen1
    choose_position
}

# Función para seleccionar monitores en modo Mirror
select_mirror_mode() {
    # Seleccionar el primer monitor
    screen1=$(show_available_menu "Select Screen 1")
    echo "Screen 1: $screen1"
    
    # Seleccionar el segundo monitor
    screen2=$(show_available_menu "Select Screen 2")
    echo "Screen 2: $screen2"

    # Establecer el modo espejo
    xrandr --output "$screen2" --same-as "$screen1"
    reconfigure
}

# Función para mostrar el menú de rofi para seleccionar un monitor
show_available_menu() {
    local prompt="$1"
    local monitors=$(xrandr --listmonitors | awk '{print $4}')
    local monitor=$(printf '%s\n' "${monitors[@]}" | rofi -dmenu -p "$prompt:")
    echo "$monitor"
}

# Función para mostrar el menú de rofi para seleccionar la posición de screen2 con respecto a screen1
choose_position() {
    local dual_options=("Right" "Left" "Up" "Down")
    local chosen_option=$(printf '%s\n' "${dual_options[@]}" | rofi -dmenu -p "Position of $screen2:")
    
    # Mapear las opciones seleccionadas a las opciones de xrandr
    case $chosen_option in
        Right)
            position="right-of"
            ;;
        Left)
            position="left-of"
            ;;
        Up)
            position="above"
            ;;
        Down)
            position="below"
            ;;
        *)
            echo "Invalid position selected."
            exit 1
            ;;
    esac

    # Configurar el segundo monitor respecto al monitor predeterminado
    xrandr --output "$screen2" --mode $resolutiontem --$position "$screen1" --rotate normal
    reconfigure
}

# Función para mostrar el menú de rofi para seleccionar la resolución de un monitor
show_resolution_menu() {
    local monitor="$1"
    local resolutions=$(get_resolutions "$monitor")
    local resolution_options=$(printf "Custom\nScreens\n%s" "$resolutions")
    local resolution=$(printf '%s\n' "$resolution_options" | rofi -dmenu -p "Resolution for $monitor:")
    echo "$resolution"
}

# Función para obtener las resoluciones disponibles para un monitor dado
get_resolutions() {
    local monitor="$1"
    xrandr | awk -v monitor="$monitor" '
        $0 ~ monitor {
            get_resolutions = 1
            next
        }
        get_resolutions && !/^ +[a-zA-Z]/ {
            match($0, /[0-9]+x[0-9]+/)
            if (RSTART) print substr($0, RSTART, RLENGTH)
        }
        !get_resolutions && /^ +[a-zA-Z]/ {
            get_resolutions = 0
        }
    '
}

# Función combinada para verificar la resolución y calcular la escala si no es compatible
check_resolution_and_calculate_scale() {
    local monitor="$1"
    local resolution="$2"
    local resolutions=$(get_resolutions "$monitor")

    for res in $resolutions; do
        if (("$res" = "$resolution")); then
            return 0
        fi
    done
    
    # Si no es compatible, calcular la escala
    local current_resolution=$(xrandr | awk -v monitor="$monitor" '
        $0 ~ monitor && / connected/ {
            match($0, /[0-9]+x[0-9]+/)
            if (RSTART) print substr($0, RSTART, RLENGTH)
        }
    ')

    IFS='x' read -r current_width current_height <<< "$current_resolution"
    IFS='x' read -r new_width new_height <<< "$resolution"

    local scale_width=$(echo "scale=2; $current_width / $new_width" | bc)
    local scale_height=$(echo "scale=2; $current_height / $new_height" | bc)

    echo "Calculated scale: $scale_width x $scale_height"
    echo "$current_resolution" "$scale_width"x"$scale_height"
    return 1
}

# Función para aplicar la resolución y la escala
apply_resolution_and_scale() {
    local monitor="$1"
    local actual_resolution="$2"
    local invalid_resolution="$3"
    local scale="$4"
    
    IFS='x' read -r scale_width scale_height <<< "$scale"
    xrandr --output "$monitor" --mode "$actual_resolution" --panning "$invalid_resolution" --scale "$scale_width"x"$scale_height"
    reconfigure
}

# Función para reconfigurar el sistema
reconfigure() {
    # qtile cmd-obj -o cmd -f reload_config
    $HOME/.config/scripts/wallpaper-rofi.sh init
}

# Mostrar menú principal
selected_option=$(echo -e "Mode\nResolution\nAvailable" | rofi -dmenu -p "Select Option:")

case "$selected_option" in
    "Mode")
        mode=$(show_mode_menu)
        echo "Selected Mode: $mode"
        ;;
    "Resolution")
        monitor=$(show_available_menu "Select Monitor")
        resolution=$(show_resolution_menu "$monitor")
        echo "Selected Resolution for $monitor: $resolution"
        
        if [ "$resolution" = "Custom" ]; then
            custom_resolution=$(rofi -dmenu -p "Enter custom resolution (e.g., 1920x1080):")
            result=$(check_resolution_and_calculate_scale "$monitor" "$custom_resolution")
            if [ $? -eq 0 ]; then
                xrandr --output "$monitor" --mode "$custom_resolution"
                reconfigure
            else
                echo "Resolution $custom_resolution is not compatible with $monitor."
                IFS=' ' read -r current_resolution scale <<< "$result"
                apply_resolution_and_scale "$monitor" "$current_resolution" "$custom_resolution" "$scale"
            fi
        elif [ "$resolution" = "Screens" ]; then
            echo "Screens option selected."
            # Aquí puedes agregar más lógica para la opción "Screens" si es necesario
        else
            xrandr --output "$monitor" --mode "$resolution"
            reconfigure
        fi
        ;;
    "Available")
        monitor=$(show_available_menu "Select Monitor")
        echo "Selected Monitor: $monitor"
        ;;
    *)
        echo "Invalid option selected."
        ;;
esac
