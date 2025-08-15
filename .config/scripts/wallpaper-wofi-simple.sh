#!/usr/bin/env bash

# Settings
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-selector"
DB_FILE="$CACHE_DIR/wallpapers.csv"

mkdir -p "$CACHE_DIR"

generate_menu_simple() {
  echo "!Update Database"
  echo "!Random Wallpaper"
  
  [[ -f "$DB_FILE" ]] || return
  
  while IFS=',' read -r hash name path; do
    hash="${hash//\"/}"
    name="${name//\"/}"
    path="${path//\"/}"
    
    [[ -f "$path" ]] || continue
    
    # Convertir guiones bajos a espacios para mejor búsqueda difusa
    display_name="${name//_/ }"
    
    # Crear texto buscable que incluya tanto el nombre original como el convertido
    search_text="$display_name ($name)"
    
    echo "$search_text"
  done < "$DB_FILE"
}

set_wallpaper() {
  local path="$1"
  swaybg -m fill -i "$path" &
  echo "$path" > "$HOME/.cache/current_wallpaper"
  notify-send "Wallpaper" "Wallpaper has been updated" -i "$path"
}

main() {
  selected=$(generate_menu_simple | wofi --show dmenu \
    --cache-file /dev/null \
    --matching fuzzy \
    --insensitive \
    --prompt "Select Wallpaper")
  
  [[ -z "$selected" ]] && exit
  
  case "$selected" in
    "!Update Database")
      echo "Updating database..."
      # Llamar función de actualización del script original si es necesario
      ;;
    "!Random Wallpaper")
      if [[ -s "$DB_FILE" ]]; then
        random_path=$(shuf -n1 "$DB_FILE" | cut -d',' -f3 | tr -d '"')
        echo "$random_path"
        [[ -f "$random_path" ]] && set_wallpaper "$random_path"
      else
        notify-send "Wallpaper Error" "No wallpapers found. Generate the database."
      fi
      ;;
    *)
      # Buscar el archivo original basado en el nombre seleccionado
      # Extraer el nombre entre paréntesis
      original_name=$(echo "$selected" | sed 's/.*(\(.*\)).*/\1/')
      original_path=$(awk -F',' -v name="\"$original_name\"" '$2 == name {gsub(/\"/, "", $3); print $3}' "$DB_FILE")
      
      if [[ -f "$original_path" ]]; then
        set_wallpaper "$original_path"
      else
        notify-send "Wallpaper Error" "Original file not found: $original_path"
      fi
      ;;
  esac
}

main
