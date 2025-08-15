#!/bin/sh

  # Screen setup

#xrandr --output eDP1 --mode 1366x768 --panning 1640x922 --scale 1.20058565x1.20208604 &
#xrandr --fb 1641x923 --output eDP1 --mode 1366x768 --panning 1640x922 --scale 1.20058565x1.20208604 &


  #keyboard default configuration

setxkbmap -layout latam &


  #System programs

sleep 3 &&

nm-applet &
#blueman-applet &

$HOME/.config/scripts/hotkeys.sh &

$HOME/.config/scripts/wallpaper-rofi.sh init &

pidof -q gpaste-daemon || setsid -f gpaste-client daemon >/dev/null 2>&1 &


#udiskie -t &
#picom &
#cbatticon -u 5 &
#volumeicon &
