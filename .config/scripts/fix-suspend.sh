#!/bin/bash

# Script manual para reparar problemas después de suspensión
# Ejecutar si algo no funciona correctamente después de despertar

echo "🔧 Reparando componentes post-suspensión..."

# Reiniciar wallpaper
echo "📸 Reiniciando wallpaper..."
pkill -f swaybg
sleep 1
if [ -f "$HOME/.cache/current_wallpaper" ]; then
    WALLPAPER=$(cat "$HOME/.cache/current_wallpaper")
    if [ -f "$WALLPAPER" ]; then
        swaybg -m fill -i "$WALLPAPER" &
        echo "✅ Wallpaper restaurado"
    else
        echo "❌ Error: wallpaper no encontrado: $WALLPAPER"
    fi
else
    echo "❌ Error: archivo current_wallpaper no encontrado"
fi

# Reiniciar yambar si es necesario
if ! pgrep yambar > /dev/null; then
    echo "📊 Reiniciando yambar..."
    yambar &
    echo "✅ Yambar reiniciado"
fi

# Reiniciar mako si es necesario
if ! pgrep -f mako > /dev/null; then
    echo "🔔 Reiniciando mako..."
    mako &
    echo "✅ Mako reiniciado"
fi

# Reiniciar udiskie si es necesario
if ! pgrep -f udiskie > /dev/null; then
    echo "💾 Reiniciando udiskie..."
    udiskie &
    echo "✅ Udiskie reiniciado"
fi

# Configurar pantallas
echo "🖥️  Configurando pantallas..."
wlr-randr --output HDMI-A-2 --below eDP-1 --transform 270 --off

echo "🎉 ¡Reparación completada!"
echo ""
echo "Servicios activos:"
echo "- Wallpaper: $(pgrep -f swaybg > /dev/null && echo '✅ OK' || echo '❌ FALLO')"
echo "- Yambar: $(pgrep yambar > /dev/null && echo '✅ OK' || echo '❌ FALLO')"
echo "- Mako: $(pgrep -f mako > /dev/null && echo '✅ OK' || echo '❌ FALLO')"
echo "- Udiskie: $(pgrep -f udiskie > /dev/null && echo '✅ OK' || echo '❌ FALLO')"
