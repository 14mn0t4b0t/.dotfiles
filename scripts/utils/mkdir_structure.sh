#!/usr/bin/env bash

# mkdir_structure.sh
# Create the directory structure of ~/.dotfiles

set -euo pipefail

BASE_DIR="${HOME}/.dotfiles"

# directory list
DIRS=(
  "${BASE_DIR}/.config/"
  #"${BASE_DIR}/.config/river"
  #"${BASE_DIR}/.config/sway/config.d"
  #"${BASE_DIR}/.config/alacritty"
  #"${BASE_DIR}/.config/nvim/lua/config"
  #"${BASE_DIR}/.config/nvim/lua/plugins"
  #"${BASE_DIR}/.config/nvim/lua/utils"
  #"${BASE_DIR}/.config/nvim/after/ftplugin"
  #"${BASE_DIR}/.config/gtk-3.0"
  #"${BASE_DIR}/.config/fontconfig"
  #"${BASE_DIR}/.config/git"
  #"${BASE_DIR}/.config/rofi/themes"
  #"${BASE_DIR}/.config/dunst"

  "${BASE_DIR}/.local/bin"
  "${BASE_DIR}/.local/share/applications/"
  #"${BASE_DIR}/.local/share/applications/steam-games"
  "${BASE_DIR}/.local/share/themes/gtk-themes"
  #"${BASE_DIR}/.local/share/themes/gtk-themes/custom-dark"
  "${BASE_DIR}/.local/share/themes/icon-themes"
  #"${BASE_DIR}/.local/share/themes/icon-themes/custom-icons"
  "${BASE_DIR}/.local/share/wallpapers"
  #"${BASE_DIR}/.local/share/wallpapers/desktop"
  #"${BASE_DIR}/.local/share/wallpapers/lockscreen"
  "${BASE_DIR}/.local/lib"

  "${BASE_DIR}/home"

  "${BASE_DIR}/scripts"
  "${BASE_DIR}/scripts/utils"
  "${BASE_DIR}/scripts/templates"

  "${BASE_DIR}/config/packages"
  "${BASE_DIR}/config/services"
  "${BASE_DIR}/config/fonts"
  "${BASE_DIR}/config/themes"
  "${BASE_DIR}/config/wm"

  "${BASE_DIR}/docs/screenshots"

  #"${BASE_DIR}/dotbot"
)

echo "Making the directory structure of ~/.dotfiles..."
for dir in "${DIRS[@]}"; do
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
    echo "Made: $dir"
  else
    echo "pass: $dir"
  fi
done

echo "The directory structure of ~/.dotfiles is done."

