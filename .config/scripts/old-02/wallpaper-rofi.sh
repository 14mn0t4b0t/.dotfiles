#!/bin/bash
#   ____ _                              _____ _                          
#  / ___| |__   __ _ _ __   __ _  ___  |_   _| |__   ___ _ __ ___   ___  
# | |   | '_ \ / _` | '_ \ / _` |/ _ \   | | | '_ \ / _ \ '_ ` _ \ / _ \ 
# | |___| | | | (_| | | | | (_| |  __/   | | | | | |  __/ | | | | |  __/ 
#  \____|_| |_|\__,_|_| |_|\__, |\___|   |_| |_| |_|\___|_| |_| |_|\___| 
#                          |___/                                         
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# Cache file for holding the current wallpaper
cache_file="$HOME/.cache/current_wallpaper"
blurred="$HOME/.cache/blurred_wallpaper.png"
rasi_file="$HOME/.cache/current_wallpaper.rasi"
wfolder="$HOME/Pictures/Wallpapers/"


# Create cache file if not exists
if [ ! -f $cache_file ] ;then
    touch $cache_file
    echo "$wfolder/default.jpg" > "$cache_file"
fi

# Create rasi file if not exists
if [ ! -f $rasi_file ] ;then
    touch $rasi_file
    echo "* { current-image: url(\"$wfolder/default.jpg\", height); }" > "$rasi_file"
fi

current_wallpaper=$(cat "$cache_file")

case $1 in

    # Load wallpaper from .cache of last session 
    "init")
        if [ -f $cache_file ]; then
            wal -q -s -t -i $current_wallpaper
        else
            wal -q -s -t -i "$wfolder"
        fi
    ;;

    # Select wallpaper with rofi
    "select")
        selected=$( find "$wfolder" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec basename {} \; | sort -R | while read rfile
        do
            echo -en "$rfile\x00icon\x1f$wfolder/${rfile}\n"
        done | rofi -dmenu -remplace -config $HOME/.local/share/rofi/wallpaper.rasi)  #$HOME/.local/share/rofi/config-wallpaper.rasi)
        if [ ! "$selected" ]; then
            echo "No wallpaper selected"
            exit
        fi
        wal -q -s -t -i "$wfolder/$selected"
    ;;

    # Randomly select wallpaper 
    *)
        wal -q -s -t -i "$wfolder"
    ;;

esac

# ----------------------------------------------------- 
# Reload qtile to color bar
# ----------------------------------------------------- 
qtile cmd-obj -o cmd -f reload_config

# ----------------------------------------------------- 
# Get new theme
# ----------------------------------------------------- 
source "$HOME/.cache/wal/colors.sh"
echo "Wallpaper: $wallpaper"
newwall=$(echo $wallpaper | sed "s|$wfolder||g")

# ----------------------------------------------------- 
# Created blurred wallpaper
# ----------------------------------------------------- 
#magick $wallpaper -resize 50% $blurred
#echo ":: Resized to 50%"
#magick $blurred -blur 50x30 $blurred
#echo ":: Blurred"
# ----------------------------------------------------- 
# Write selected wallpaper into .cache files
# ----------------------------------------------------- 
echo "$wallpaper" > "$cache_file"
echo "* { current-image: url(\"$wallpaper\", height); }" > "$rasi_file"

sleep 1

# ----------------------------------------------------- 
# Send notification
# ----------------------------------------------------- 
#notify-send "Colors and Wallpaper updated" "with image $newwall"
echo "Done."
