# 🏠 Estructura completa de dotfiles

## 📁 Árbol de directorios

```
~/.dotfiles/
├── .config/                     # Configuraciones XDG
│   ├── river/
│   │   ├── init                 # Script de inicio de River WM
│   │   └── autostart           # Aplicaciones que se inician con River
│   ├── sway/
│   │   ├── config              # Configuración principal de Sway
│   │   └── config.d/           # Configuraciones modulares
│   │       ├── input           # Configuración de input devices
│   │       ├── output          # Configuración de monitores
│   │       └── keybindings     # Atajos de teclado
│   ├── alacritty/
│   │   └── alacritty.yml       # Configuración del terminal
│   ├── waybar/
│   │   ├── config              # Configuración de waybar
│   │   ├── style.css           # Estilos CSS
│   │   └── modules/            # Módulos personalizados
│   │       ├── battery.json
│   │       ├── network.json
│   │       └── workspaces.json
│   ├── nvim/
│   │   ├── init.lua            # Configuración principal de Neovim
│   │   ├── lua/
│   │   │   ├── config/         # Configuraciones generales
│   │   │   │   ├── options.lua
│   │   │   │   ├── keymaps.lua
│   │   │   │   └── autocmds.lua
│   │   │   ├── plugins/        # Configuración de plugins
│   │   │   │   ├── lsp.lua
│   │   │   │   ├── treesitter.lua
│   │   │   │   ├── telescope.lua
│   │   │   │   └── init.lua
│   │   │   └── utils/          # Utilidades personalizadas
│   │   │       └── helpers.lua
│   │   └── after/              # Configuraciones que se cargan al final
│   │       └── ftplugin/
│   │           ├── lua.lua
│   │           ├── python.lua
│   │           └── markdown.lua
│   ├── gtk-3.0/
│   │   ├── settings.ini        # Configuración de GTK3
│   │   └── gtk.css             # Estilos personalizados GTK
│   ├── fontconfig/
│   │   └── fonts.conf          # Configuración de fuentes
│   ├── git/
│   │   ├── config              # Configuración de Git
│   │   └── ignore              # Gitignore global
│   ├── rofi/
│   │   ├── config.rasi         # Configuración de rofi
│   │   └── themes/
│   │       └── custom.rasi
│   ├── dunst/
│   │   └── dunstrc             # Notificaciones
│   └── mimeapps.list           # Asociaciones de aplicaciones por defecto
│
├── .local/                      # Binarios y datos locales del usuario
│   ├── bin/                    # Scripts ejecutables personales
│   │   ├── screenshot          # Script para capturas de pantalla
│   │   ├── toggle-theme        # Cambiar entre tema claro/oscuro
│   │   ├── mount-usb          # Montar dispositivos USB
│   │   ├── backup-dotfiles    # Hacer backup de configuraciones
│   │   ├── wm-logout          # Script de cierre de sesión
│   │   ├── update-system      # Actualizar sistema y paquetes AUR
│   │   ├── brightness-control # Control de brillo
│   │   ├── volume-control     # Control de volumen
│   │   └── lock-screen        # Bloquear pantalla
│   ├── share/
│   │   ├── applications/       # .desktop files personalizados
│   │   │   ├── custom-app.desktop
│   │   │   └── steam-games/    # Accesos directos de juegos
│   │   ├── themes/            # Temas personalizados
│   │   │   ├── gtk-themes/
│   │   │   │   └── custom-dark/
│   │   │   └── icon-themes/
│   │   │       └── custom-icons/
│   │   └── wallpapers/        # Fondos de pantalla
│   │       ├── desktop/
│   │       │   ├── mountain.jpg
│   │       │   ├── forest.jpg
│   │       │   └── abstract.png
│   │       ├── lockscreen/
│   │       │   └── lock.jpg
│   │       └── current -> desktop/mountain.jpg  # Enlace al actual
│   └── lib/                   # Librerías personales (si las hay)
│
├── home/                       # Archivos que van directamente en $HOME
│   ├── .bashrc                # Configuración de Bash
│   ├── .zshrc                 # Configuración de Zsh
│   ├── .profile               # Variables de entorno generales
│   ├── .xinitrc               # Configuración para startx
│   ├── .xprofile              # Variables para sesiones X11
│   ├── .gitconfig             # Configuración global de Git
│   ├── .gitignore_global      # Gitignore global
│   ├── .npmrc                 # Configuración de npm
│   ├── .vimrc                 # Configuración básica de Vim (fallback)
│   ├── .editorconfig          # Configuración de editores
│   ├── .tmux.conf             # Configuración de tmux
│   └── .inputrc               # Configuración de readline
│
├── scripts/                    # Scripts para automatizar instalación
│   ├── install-packages.sh     # Instalar paquetes del sistema
│   ├── setup-services.sh       # Configurar y habilitar servicios
│   ├── setup-wm.sh            # Configuración específica del WM
│   ├── post-install.sh        # Tareas posteriores a la instalación
│   ├── utils/                 # Scripts auxiliares
│   │   ├── detect-distro.sh   # Detectar distribución Linux
│   │   ├── backup.sh          # Crear backups antes de instalar
│   │   ├── cleanup.sh         # Limpiar configuraciones rotas
│   │   ├── verify-install.sh  # Verificar instalación
│   │   ├── colors.sh          # Funciones para output colorido
│   │   └── common.sh          # Funciones comunes
│   └── templates/             # Templates para generar configs
│       ├── gitconfig.template # Template de .gitconfig con variables
│       ├── waybar-config.template
│       └── user-dirs.template
│
├── config/                     # Archivos de configuración para scripts
│   ├── packages/              # Listas de paquetes por distribución
│   │   ├── arch.txt           # Paquetes de repos oficiales de Arch
│   │   ├── arch-aur.txt       # Paquetes del AUR
│   │   ├── debian.txt         # Paquetes para Debian/Ubuntu
│   │   ├── fedora.txt         # Paquetes para Fedora
│   │   └── common.txt         # Paquetes disponibles en todas las distros
│   ├── services/              # Configuración de servicios
│   │   ├── arch-services.txt  # Servicios systemd para Arch
│   │   ├── user-services.txt  # Servicios de usuario
│   │   └── optional-services.txt  # Servicios opcionales
│   ├── fonts/                 # Configuración de fuentes
│   │   ├── fonts-list.txt     # Lista de fuentes a instalar
│   │   └── nerd-fonts.txt     # Fuentes Nerd específicas
│   ├── themes/                # Configuración de temas
│   │   ├── gtk-themes.txt
│   │   └── icon-themes.txt
│   ├── wm/                   # Configuraciones específicas por WM
│   │   ├── river-deps.txt    # Dependencias específicas de River
│   │   ├── sway-deps.txt     # Dependencias específicas de Sway
│   │   └── shared-deps.txt   # Dependencias compartidas entre WMs
│   └── variables.env         # Variables de configuración
│
├── docs/                      # Documentación del setup
│   ├── README.md             # Documentación principal
│   ├── INSTALL.md            # Guía de instalación paso a paso
│   ├── KEYBINDS.md          # Lista de atajos de teclado
│   ├── TROUBLESHOOTING.md   # Solución de problemas comunes
│   ├── CUSTOMIZATION.md     # Cómo personalizar las configuraciones
│   └── screenshots/         # Capturas de pantalla del setup
│       ├── desktop.png
│       ├── terminal.png
│       ├── applications.png
│       └── workflow.gif
│
├── .gitignore               # Archivos que Git debe ignorar
├── .gitmodules             # Submódulos de Git (dotbot)
├── dotbot/                 # Submódulo de dotbot (generado)
├── install.conf.yaml       # Configuración de dotbot
├── install                 # Script ejecutable de dotbot
├── setup                   # Script maestro de instalación
├── LICENSE                 # Licencia del proyecto
└── README.md              # Documentación básica del repositorio
```

## 📝 Archivos de configuración incluidos

### Archivos principales:
- **install.conf.yaml**: 150 líneas de configuración de dotbot
- **setup**: Script maestro de 200+ líneas
- **README.md**: Documentación completa con badges
- **.gitignore**: Exclusiones para Git

### Scripts de instalación:
- **scripts/install-packages.sh**: ~100 líneas
- **scripts/setup-services.sh**: ~80 líneas
- **scripts/setup-wm.sh**: ~150 líneas
- **scripts/post-install.sh**: ~100 líneas

### Configuraciones de aplicaciones:
- **River WM**: Script init completo
- **Waybar**: Configuración modular
- **Alacritty**: Configuración con tema
- **Neovim**: Setup completo con Lua
- **Zsh/Bash**: Configuraciones optimizadas

### Listas de paquetes:
- **Arch Linux**: 50+ paquetes esenciales
- **AUR**: 20+ paquetes adicionales
- **Debian/Ubuntu**: Equivalentes adaptados

### Utilidades:
- **15+ scripts** en .local/bin/
- **Templates** configurables
- **Documentación** completa

## 🎯 Total del proyecto:
- **80+ archivos** de configuración
- **500+ líneas** de scripts
- **Documentación** completa
- **Estructura** modular y escalable
- **Compatibilidad** multi-distro