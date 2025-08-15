#!/bin/bash

# gpu_nvidia_mx450.sh - Monitor para GPU NVIDIA MX450
#
# Métricas:
# 1. Uso de GPU (%)
# 2. Memoria usada (MB)
# 3. Temperatura (°C)
#
# Uso: gpu_nvidia_mx450.sh INTERVALO_SEGUNDOS

interval=${1:-2}  # Default 2 segundos

# Verificar dependencias
if ! command -v nvidia-smi &>/dev/null; then
    echo "gpu_usage|range:0-100|0"
    echo "gpu_mem_used|number|0"
    echo "gpu_temp|range:0-100|0"
    echo ""
    echo "Error: nvidia-smi no encontrado" >&2
    exit 1
fi

while true; do
    # Consulta optimizada según tu preferencia
    IFS=', ' read -r gpu_usage mem_used gpu_temp <<< \
        $(nvidia-smi --query-gpu=utilization.gpu,memory.used,temperature.gpu --format=csv,noheader,nounits)

    # Limpiar memoria (ejemplo: "1234MiB" → "1234")
    mem_used=${mem_used/MiB/}

    # Emitir métricas para yambar
    echo "gpu_usage|range:0-100|${gpu_usage:-0}"
    echo "gpu_mem_used|string|${mem_used:-0}"
    echo "gpu_temp|range:0-100|${gpu_temp:-0}"
    echo ""

    sleep "$interval"
done
