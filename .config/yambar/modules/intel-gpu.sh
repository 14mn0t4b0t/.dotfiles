#!/bin/bash

# intel-gpu.sh - Monitor eficiente para GPU Intel usando stream continuo
# Solo muestra: Uso (%) y Consumo (W)
# Trata intel_gpu_top como stream de datos cada 2 segundos

# Verificar dependencias
if ! command -v intel_gpu_top &>/dev/null; then
    echo "gpu_usage|range:0-100|0"
    echo "gpu_power|string|0.00"
    echo ""
    exit 1
fi

# Función para procesar línea de datos
process_gpu_line() {
    local line="$1"
    
    # Verificar que sea una línea de datos (empieza con números)
    if [[ $line =~ ^[[:space:]]*[0-9] ]]; then
        # Parsear campos: freq_req freq_act irq rc6 gpu_power pkg_power rcs_busy ...
        local fields=($line)
        local gpu_power=${fields[4]:-0}   # GPU power (índice 4, columna 5)
        local gpu_usage=${fields[6]:-0}   # RCS busy (índice 6, columna 7)
        
        # Formatear valores (entero para %, 2 decimales para W)
        gpu_usage=$(printf "%.0f" "${gpu_usage}" 2>/dev/null || echo "0")
        gpu_power=$(printf "%.2f" "${gpu_power}" 2>/dev/null || echo "0.00")
        
        # Salida para yambar
        echo "gpu_usage|range:0-100|${gpu_usage}"
        echo "gpu_power|string|${gpu_power}"
        echo ""
    fi
}

# Trap para limpiar procesos al salir
trap 'jobs -p | xargs -r kill; exit' EXIT

# Iniciar intel_gpu_top como stream continuo y procesar línea por línea
intel_gpu_top -l -s 2000 2>/dev/null | while IFS= read -r line; do
    process_gpu_line "$line"
done
