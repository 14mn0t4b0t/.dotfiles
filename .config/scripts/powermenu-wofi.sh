#!/bin/bash
#  ____                                                    
# |  _ \ _____      _____ _ __ _ __ ___   ___ _ __  _   _  
# | |_) / _ \ \ /\ / / _ \ '__| '_ ` _ \ / _ \ '_ \| | | | 
# |  __/ (_) \ V  V /  __/ |  | | | | | |  __/ | | | |_| | 
# |_|   \___/ \_/\_/ \___|_|  |_| |_| |_|\___|_| |_|\__,_| 
#                                                          
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# Power menu script using rofi

CHOSEN=$(printf "Lock\nSuspend\nHibernate\nReboot\nShutdown" | wofi -dmenu -i)

case "$CHOSEN" in
	"Lock") waylock ;;
	"Suspend") kitty waylock & systemctl suspend;;
        "Hibernate") kitty waylock & sleep 1 && systemctl hibernate;;
	"Reboot") reboot ;;
	"Shutdown") poweroff ;;
	*) exit 1 ;;
esac
