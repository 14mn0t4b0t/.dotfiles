Perfecto, aquí tienes la estructura completa del proyecto con todos los archivos:Ahora te voy a crear los archivos principales para que puedas empezar inmediatamente:Para empezar tu proyecto, ejecuta estos comandos:

```bash
# 1. Crear el directorio principal
mkdir -p ~/.dotfiles
cd ~/.dotfiles

# 2. Inicializar Git
git init
git remote add origin https://github.com/tuusuario/dotfiles.git

# 3. Crear la estructura de carpetas
mkdir -p .config/{river,sway,alacritty,waybar,nvim,gtk-3.0,fontconfig,git,rofi,dunst}
mkdir -p .local/{bin,share/{applications,themes,wallpapers}}
mkdir -p home
mkdir -p scripts/{utils,templates}
mkdir -p config/{packages,services,fonts,themes,wm}
mkdir -p docs/screenshots

# 4. Agregar dotbot como submódulo
git submodule add https://github.com/anishathalye/dotbot
git config -f .gitmodules submodule.dotbot.ignore dirty

# 5. Crear enlaces para el script de instalación
cp dotbot/tools/git-submodule/install .
chmod +x install

# 6. Copiar los archivos principales desde el artifact
# (Copia el contenido del artifact anterior a los archivos correspondientes)

# 7. Hacer el setup ejecutable
chmod +x setup

# 8. Primer commit
git add .
git commit -m "🎉 Initial dotfiles setup"
```

¿Quieres que continúe creando algunos de los scripts específicos como `install-packages.sh` o las configuraciones básicas de River y Alacritty?
