#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export GTK_THEME=Juno-ocean
export XCURSOR_THEME=miniature
#export XCURSOR_SIZE=24

# QT5 FIX
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=qt5ct
# Wayland Fix
export QT_QPA_PLATFORM="wayland;xcb"
export XDG_CURRENT_DESKTOP=river
export XDG_SESSION_DESKTOP=river
export XDG_CURRENT_SESSION_TYPE=wayland
export GDK_BACKEND="wayland,x11"
export MOZ_ENABLE_WAYLAND=1
