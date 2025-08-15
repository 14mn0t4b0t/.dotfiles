#!/bin/bash

# cpu_temp.sh - monitors CPU package temperature
#
# Usage: cpu_temp.sh INTERVAL_IN_SECONDS
#
# Emits:
#  temp|range:20-100|TEMPERATURE

interval=${1:-2}  # Default 2 seconds

case ${interval} in
    ''|*[!0-9]*) echo "Interval must be integer" >&2; exit 1 ;;
esac

while true; do
    # Extrae solo la temperatura del package (primera línea que contiene "Package id 0")
    temp=$(sensors | awk '/Package id 0/{print $4}' | cut -c2- | cut -d. -f1)
    
    # Verifica si obtuvimos un valor numérico válido
    if [[ $temp =~ ^[0-9]+$ ]]; then
        echo "temp|range:20-100|$temp"
    else
        echo "temp|range:20-100|0"
        echo "Error reading temperature" >&2
    fi
    
    echo ""
    sleep "$interval"
done
