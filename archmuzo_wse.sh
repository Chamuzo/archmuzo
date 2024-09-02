#!/bin/bash

# Actualizar el sistema
sudo pacman -Syu --noconfirm

# Instalar paquetes comunes necesarios
sudo pacman -S --noconfirm xorg-xwayland xorg-xlsclients mesa alacritty

# Instalar Sway
sudo pacman -S --noconfirm sway swaybg swayidle swaylock

# Instalar Wayfire
sudo pacman -S --noconfirm wayfire wf-shell

# Instalar River
sudo pacman -S --noconfirm river

# Instalar Hyprland
sudo pacman -S --noconfirm hyprland

# Instalar Newm
sudo pacman -S --noconfirm newm

# Configurar para iniciar Sway automáticamente al iniciar sesión
if ! grep -q 'exec sway' ~/.bash_profile; then
  echo "if [ -z \"\$DISPLAY\" ] && [ \"\$(tty)\" = \"/dev/tty1\" ]; then" >> ~/.bash_profile
  echo "  exec sway" >> ~/.bash_profile  # Cambia 'sway' por 'wayfire', 'river', 'hyprland', o 'newm' según tu preferencia
  echo "fi" >> ~/.bash_profile
fi

# Configuración básica para Sway
mkdir -p ~/.config/sway
cat <<EOF > ~/.config/sway/config
# Configuración básica para Sway

# Definir la salida de video
output * bg #000000 solid_color

# Teclas de inicio
set \$mod Mod4

# Terminal
bindsym \$mod+Return exec alacritty

# Salir de Sway
bindsym \$mod+Shift+e exec "swaymsg exit"
EOF

# Configuración básica para Wayfire
mkdir -p ~/.config/wayfire
cat <<EOF > ~/.config/wayfire.ini
# Configuración básica para Wayfire
[core]
plugins = wl-shell, vswitch, expo, simple-tile, simple-tile-backend, animated-workspaces, cube, vswitch-backend, wf-swipe, wayfire-screenshot
vwidth = 1920
vheight = 1080
EOF

# Configuración básica para River
mkdir -p ~/.config/river
cat <<EOF > ~/.config/river/init
#!/bin/sh
# Configuración básica para River
riverctl spawn "alacritty"
EOF
chmod +x ~/.config/river/init

# Configuración básica para Hyprland
mkdir -p ~/.config/hypr
cat <<EOF > ~/.config/hypr/hyprland.conf
# Configuración básica para Hyprland
monitor=,preferred
exec=alacritty
EOF

# Configuración básica para Newm
mkdir -p ~/.config/newm
cat <<EOF > ~/.config/newm/newm.conf
# Configuración básica para Newm
exec-always = "alacritty"
screenlock-timeout = 5
EOF

# Recordatorio final
echo "La instalación y configuración básica está completa. Reinicia tu sesión o cierra la terminal y vuelve a iniciar sesión para entrar directamente en Sway."
echo "Si deseas usar otro compositor, edita ~/.bash_profile y reemplaza 'exec sway' por el compositor de tu elección."
