#!/bin/bash

# Actualizar el sistema
sudo pacman -Syu --noconfirm

# Instalar soporte para Wayland
sudo pacman -S --noconfirm wayland xorg-xwayland xorg-xlsclients mesa

# Instalar Newm
sudo pacman -S --noconfirm newm

# Configuración básica para Newm
mkdir -p ~/.config/newm
cat <<EOF > ~/.config/newm/newm.conf
# Configuración básica para Newm
exec-always = "alacritty"
screenlock-timeout = 5

# Opciones adicionales pueden ser agregadas aquí
EOF

# Instalar SDDM (Display Manager compatible con Wayland)
sudo pacman -S --noconfirm sddm

# Habilitar SDDM para que inicie automáticamente
sudo systemctl enable sddm

# Configurar SDDM para usar Wayland
sudo mkdir -p /etc/sddm.conf.d
cat <<EOF | sudo tee /etc/sddm.conf.d/wayland.conf
[General]
InputMethod=

[Autologin]
Relogin=false

[Wayland]
Session=newm.desktop

[X11]
Session=newm.desktop
EOF

# Recordatorio final
echo "La instalación y configuración de Wayland, Newm, y SDDM está completa."
echo "Puedes reiniciar tu sistema para iniciar sesión en la interfaz gráfica con Newm."

