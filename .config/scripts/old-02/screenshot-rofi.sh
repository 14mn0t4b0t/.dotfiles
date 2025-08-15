#!/bin/bash
#  ____                               _           _    
# / ___|  ___ _ __ ___  ___ _ __  ___| |__   ___ | |_  
# \___ \ / __| '__/ _ \/ _ \ '_ \/ __| '_ \ / _ \| __| 
#  ___) | (__| | |  __/  __/ | | \__ \ | | | (_) | |_  
# |____/ \___|_|  \___|\___|_| |_|___/_| |_|\___/ \__|  
# ----------------------------------------------------- 

DIR="$HOME/Pictures/screenshots/"
NAME="screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

import -window root "$DIR$NAME" && cat "$DIR$NAME" | xclip -selection clipboard -t image/png &&

option1="Fullscreen"
option2="Area"
option3="Window"
option4="Preview"
option5="Delete"

options="$option1\n$option2\n$option5\n$option4\n$option3"

feh -F -Z "$DIR$NAME" &




choice=$(echo -e "$options" | rofi -i -dmenu -p "Take Screenshot")
case $choice in
    $option1)
        sleep 1
        notify-send "Screenshot Fullscreen" "Mode: Fullscreen"       
    ;;
    $option2)
        rm -f "$DIR$NAME"
        scrot $DIR$NAME -s -e 'xclip -selection clipboard -t image/png -i $f'
        notify-send "Screenshot created" "Mode: Selected area"
        
    ;;
    $option3)
        killall feh
        rm -f "$DIR$NAME"
        scrot $DIR$NAME -d 1 -e 'xclip -selection clipboard -t image/png -i $f' -c -z -u
        feh -F -Z "$DIR$NAME"
        notify-send "Screenshot created" "Mode: Selected window"
        
    ;;
    $option4)
        killall feh
        feh -F -Z "$DIR$NAME" || bash "$0"
        bash "$0"
    ;;
    $option5)
        killall feh
        rm -f "$DIR$NAME"
    ;;
esac
