#!/bin/bash

# Actualizar el sistema
sudo pacman -Syu --noconfirm

# Instalar dependencias necesarias
sudo pacman -S --noconfirm base-devel git cmake meson ninja \
    libx11 libxinerama libxcomposite libxrandr libxdamage \
    libxfixes libxext libxi xcb-util-wm xcb-util-xrm xorg-xwayland

# Instalar Wayland y Sway
sudo pacman -S --noconfirm wayland wayland-protocols sway

# Clonar e instalar Hyprland
git clone https://github.com/vaxerski/Hyprland
cd Hyprland
make
sudo make install
cd ..

# Crear directorio de configuración de Hyprland
mkdir -p ~/.config/hypr

# Crear archivo de configuración de Hyprland
cat <<EOL > ~/.config/hypr/hyprland.conf
monitor=,preferred,auto
layout=default
exec=foot
EOL

# Instalar un terminal y un launcher
sudo pacman -S --noconfirm foot wofi

# Mensaje final
echo "La instalación de Hyprland ha sido completada. Puedes iniciar Hyprland ejecutando el comando 'Hyprland'."
