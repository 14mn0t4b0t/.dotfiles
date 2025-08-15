#!/usr/bin/env bash

# Configurar las variables de entorno
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_CONFIG_HOME=/home/maeda/.config
echo "HOME=$HOME"

# Comandos que se ejecutan después
killall swhks
killall swhkd

su maeda -c 'swhks &'

sleep 1

pkexec env XDG_RUNTIME_DIR=/run/user/1000 XDG_CONFIG_HOME=/home/maeda/.config swhkd

#pkexec swhkd

while true; do
    sleep 60
done
