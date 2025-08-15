# =============================================================================
# ARCHIVO 1: install.conf.yaml
# =============================================================================
- defaults:
    link:
      relink: true
      create: true
      force: true

- clean: 
  - '~/.config'
  - '~/.local/bin'

# =============================================================================
# Archivos del directorio home/
# =============================================================================
- link:
    ~/.bashrc: home/.bashrc
    ~/.zshrc: home/.zshrc
    ~/.profile: home/.profile
    ~/.xinitrc: home/.xinitrc
    ~/.xprofile: home/.xprofile
    ~/.gitconfig: home/.gitconfig
    ~/.gitignore_global: home/.gitignore_global
    ~/.vimrc: home/.vimrc
    ~/.editorconfig: home/.editorconfig
    ~/.tmux.conf: home/.tmux.conf
    ~/.inputrc: home/.inputrc

# =============================================================================
# Configuraciones XDG (.config/)
# =============================================================================
- link:
    # Window Managers
    ~/.config/river: .config/river
    # ~/.config/sway: .config/sway  # Descomenta si usas Sway
    
    # Terminal y shells
    ~/.config/alacritty: .config/alacritty
    
    # Editor
    ~/.config/nvim: .config/nvim
    
    # UI y temas
    ~/.config/waybar: .config/waybar
    ~/.config/gtk-3.0: .config/gtk-3.0
    ~/.config/fontconfig: .config/fontconfig
    ~/.config/rofi: .config/rofi
    ~/.config/dunst: .config/dunst
    
    # Git
    ~/.config/git: .config/git
    
    # Asociaciones de archivos
    ~/.config/mimeapps.list: .config/mimeapps.list

# =============================================================================
# Binarios y datos locales (.local/)
# =============================================================================
- link:
    ~/.local/bin: .local/bin
    ~/.local/share/applications: .local/share/applications
    ~/.local/share/themes: .local/share/themes
    ~/.local/share/wallpapers: .local/share/wallpapers

# =============================================================================
# Tareas post-instalación
# =============================================================================
- shell:
    - [scripts/utils/verify-install.sh, Verifying installation]
    - [chmod +x ~/.local/bin/*, Making scripts executable]
    - [fc-cache -fv, Rebuilding font cache]

# =============================================================================
# ARCHIVO 2: setup (Script maestro)
# =============================================================================
#!/bin/bash
set -e

# =============================================================================
# DOTFILES SETUP SCRIPT
# =============================================================================
# Autor: Tu nombre
# Descripción: Script maestro para instalar y configurar dotfiles
# Uso: ./setup [wm] [opciones]
# =============================================================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Funciones de logging
log() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Banner
show_banner() {
    echo -e "${PURPLE}"
    cat << "EOF"
    ╔══════════════════════════════════════╗
    ║           DOTFILES SETUP             ║
    ║     Configuración automatizada       ║
    ╚══════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Variables globales
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
WM="${1:-river}"  # Window Manager por defecto
DISTRO=""
USER_NAME=$(whoami)
HOME_DIR="$HOME"

# Cargar funciones comunes
source "$DOTFILES_DIR/scripts/utils/common.sh"
source "$DOTFILES_DIR/scripts/utils/colors.sh"

# Función principal
main() {
    show_banner
    
    log "Iniciando configuración de dotfiles..."
    log "Usuario: $USER_NAME"
    log "Directorio: $DOTFILES_DIR"
    log "Window Manager: $WM"
    
    # 1. Verificar dependencias básicas
    check_dependencies
    
    # 2. Detectar distribución
    detect_distribution
    
    # 3. Crear backup de configuraciones existentes
    create_backup
    
    # 4. Instalar paquetes del sistema
    install_system_packages
    
    # 5. Configurar servicios del sistema
    setup_system_services
    
    # 6. Configurar window manager específico
    setup_window_manager "$WM"
    
    # 7. Aplicar configuraciones de dotfiles
    apply_dotfiles
    
    # 8. Tareas post-instalación
    post_installation_tasks
    
    # 9. Mostrar resumen final
    show_summary
}

# Verificar dependencias básicas
check_dependencies() {
    log "Verificando dependencias básicas..."
    
    local deps=("git" "curl" "wget")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -ne 0 ]]; then
        error "Dependencias faltantes: ${missing[*]}"
    fi
    
    success "Dependencias básicas verificadas"
}

# Detectar distribución Linux
detect_distribution() {
    log "Detectando distribución del sistema..."
    
    if [[ -f /etc/arch-release ]]; then
        DISTRO="arch"
        info "Distribución detectada: Arch Linux"
    elif [[ -f /etc/debian_version ]]; then
        DISTRO="debian"
        info "Distribución detectada: Debian/Ubuntu"
    elif [[ -f /etc/fedora-release ]]; then
        DISTRO="fedora"
        info "Distribución detectada: Fedora"
    else
        warn "Distribución no reconocida, continuando con configuración genérica"
        DISTRO="unknown"
    fi
}

# Crear backup de configuraciones existentes
create_backup() {
    log "Creando backup de configuraciones existentes..."
    "$DOTFILES_DIR/scripts/utils/backup.sh"
}

# Instalar paquetes del sistema
install_system_packages() {
    log "Instalando paquetes del sistema..."
    "$DOTFILES_DIR/scripts/install-packages.sh" "$DISTRO" "$WM"
}

# Configurar servicios del sistema
setup_system_services() {
    log "Configurando servicios del sistema..."
    "$DOTFILES_DIR/scripts/setup-services.sh" "$DISTRO"
}

# Configurar window manager específico
setup_window_manager() {
    local wm=$1
    log "Configurando window manager: $wm"
    "$DOTFILES_DIR/scripts/setup-wm.sh" "$wm"
}

# Aplicar configuraciones de dotfiles
apply_dotfiles() {
    log "Aplicando configuraciones de dotfiles..."
    
    # Verificar que dotbot esté disponible
    if [[ ! -f "$DOTFILES_DIR/install" ]]; then
        log "Inicializando dotbot..."
        git submodule update --init --recursive
    fi
    
    # Ejecutar dotbot
    "$DOTFILES_DIR/install"
}

# Tareas post-instalación
post_installation_tasks() {
    log "Ejecutando tareas post-instalación..."
    "$DOTFILES_DIR/scripts/post-install.sh" "$WM"
}

# Mostrar resumen final
show_summary() {
    echo -e "\n${GREEN}╔══════════════════════════════════════╗"
    echo -e "║        INSTALACIÓN COMPLETADA        ║"
    echo -e "╚══════════════════════════════════════╝${NC}\n"
    
    echo -e "${WHITE}Resumen de la instalación:${NC}"
    echo -e "  ${CYAN}•${NC} Distribución: ${YELLOW}$DISTRO${NC}"
    echo -e "  ${CYAN}•${NC} Window Manager: ${YELLOW}$WM${NC}"
    echo -e "  ${CYAN}•${NC} Usuario: ${YELLOW}$USER_NAME${NC}"
    echo -e "  ${CYAN}•${NC} Dotfiles: ${YELLOW}$DOTFILES_DIR${NC}"
    
    echo -e "\n${WHITE}Próximos pasos:${NC}"
    echo -e "  ${CYAN}1.${NC} Reinicia tu sistema: ${YELLOW}sudo reboot${NC}"
    echo -e "  ${CYAN}2.${NC} Inicia sesión en $WM"
    echo -e "  ${CYAN}3.${NC} Lee la documentación: ${YELLOW}docs/README.md${NC}"
    
    echo -e "\n${WHITE}Comandos útiles:${NC}"
    echo -e "  ${CYAN}•${NC} Cambiar WM: ${YELLOW}./setup sway${NC}"
    echo -e "  ${CYAN}•${NC} Actualizar configs: ${YELLOW}./install${NC}"
    echo -e "  ${CYAN}•${NC} Ver atajos: ${YELLOW}cat docs/KEYBINDS.md${NC}"
    
    echo -e "\n${GREEN}¡Disfruta tu nuevo setup! 🎉${NC}"
}

# Manejo de argumentos
case "$1" in
    -h|--help)
        echo "Uso: $0 [wm] [opciones]"
        echo "  wm: river, sway, hyprland (default: river)"
        echo "Opciones:"
        echo "  -h, --help    Mostrar esta ayuda"
        echo "  --no-backup   Omitir creación de backup"
        echo "  --packages-only  Solo instalar paquetes"
        exit 0
        ;;
    --version)
        echo "Dotfiles Setup v1.0.0"
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac

# =============================================================================
# ARCHIVO 3: .gitignore
# =============================================================================
# Archivos temporales
*.tmp
*.swp
*.swo
*~

# Archivos de backup
*.backup
*.bak
backup/

# Logs
*.log

# Archivos específicos del sistema
.DS_Store
Thumbs.db

# Archivos de configuración personal/secretos
config/variables.env
config/secrets/
.env.local

# Cache y builds
*.cache
node_modules/
__pycache__/

# Archivos específicos del editor
.vscode/
.idea/

# Archivos de prueba
test/
testing/

# =============================================================================
# ARCHIVO 4: README.md (Principal)
# =============================================================================
# 🏠 Dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell](https://img.shields.io/badge/Shell-Bash%2FZsh-blue.svg)](https://www.gnu.org/software/bash/)
[![WM](https://img.shields.io/badge/WM-River%2FSway-green.svg)](https://github.com/riverwm/river)

> 🚀 Configuraciones automatizadas para un entorno de desarrollo productivo en Linux

## 📸 Screenshots

![Desktop](docs/screenshots/desktop.png)

## ✨ Características

- 🏃 **Instalación automatizada** con un solo comando
- 🪟 **Múltiples WM**: River, Sway, Hyprland
- 🎨 **Tema coherente** en todas las aplicaciones
- 📦 **Gestión de paquetes** automática
- 🔧 **Scripts personalizados** incluidos
- 📚 **Documentación completa**
- 🔄 **Fácil actualización** y mantenimiento

## 🚀 Instalación rápida

```bash
# Clonar repositorio
git clone https://github.com/tuusuario/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Instalación completa
./setup river  # o sway, hyprland

# Solo aplicar configuraciones (si ya tienes los paquetes)
./install
```

## 📋 Aplicaciones incluidas

### Window Managers
- **River WM** - Compositor Wayland dinámico
- **Sway** - i3 para Wayland
- **Hyprland** - Compositor con efectos

### Terminal y Shell
- **Alacritty** - Terminal acelerado por GPU
- **Zsh** + **Oh My Zsh** - Shell avanzado
- **Tmux** - Multiplexor de terminal

### Editor
- **Neovim** - Editor moderno con LSP

### UI y Herramientas
- **Waybar** - Barra de estado
- **Rofi** - Lanzador de aplicaciones
- **Dunst** - Notificaciones

## 🗂️ Estructura del proyecto

```
~/.dotfiles/
├── .config/         # Configuraciones XDG
├── .local/          # Scripts y binarios personales
├── home/            # Archivos del directorio home
├── scripts/         # Scripts de instalación
├── config/          # Configuraciones de instalación
├── docs/            # Documentación
├── setup            # Script maestro
└── install          # Script de dotbot
```

## 📖 Documentación

- [🔧 Guía de instalación](docs/INSTALL.md)
- [⌨️ Atajos de teclado](docs/KEYBINDS.md)
- [🎨 Personalización](docs/CUSTOMIZATION.md)
- [🐛 Solución de problemas](docs/TROUBLESHOOTING.md)

## 🛠️ Personalización

```bash
# Cambiar de window manager
./setup sway

# Editar configuraciones
nvim .config/river/init

# Aplicar cambios
./install
```

## 📝 Licencia

[MIT](LICENSE) © Tu nombre