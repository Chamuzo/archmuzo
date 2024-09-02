#!/bin/bash

# Solicitar variables al usuario
read -p "Introduce el hostname: " hostname
read -p "Introduce la contraseña del root: " -s root_password
echo
read -p "Introduce el nombre de la nueva cuenta de usuario (sudo): " username
read -p "Introduce la contraseña del nuevo usuario: " -s user_password
echo
read -p "Introduce la partición EFI (por ejemplo, /dev/nvme0n1p1): " efi_partition
read -p "Introduce la partición root (por ejemplo, /dev/nvme0n1p2): " root_partition
read -p "Introduce la partición home (deja en blanco si no hay): " home_partition
read -p "Introduce la partición swap (deja en blanco si no hay): " swap_partition

# Formatear las particiones
echo "Formateando las particiones..."
mkfs.fat -F32 $efi_partition
mkfs.ext4 $root_partition

if [ -n "$home_partition" ]; then
    mkfs.ext4 $home_partition
fi

if [ -n "$swap_partition" ]; then
    mkswap $swap_partition
fi

# Montar las particiones
echo "Montando las particiones..."
mount $root_partition /mnt
mkdir /mnt/boot
mount $efi_partition /mnt/boot

if [ -n "$home_partition" ]; then
    mkdir /mnt/home
    mount $home_partition /mnt/home
fi

if [ -n "$swap_partition" ]; then
    swapon $swap_partition
fi

# Instalar el sistema base
echo "Instalando el sistema base..."
pacstrap /mnt base linux linux-firmware

# Generar fstab
echo "Generando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot al nuevo sistema
echo "Entrando en chroot..."
arch-chroot /mnt /bin/bash <<EOF

# Configurar la zona horaria
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

# Configurar el locale
echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf

# Configurar vconsole.conf (opcional)
echo "KEYMAP=es" > /etc/vconsole.conf

# Configurar el hostname
echo "$hostname" > /etc/hostname

# Configurar hosts
cat <<EOT > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain $hostname
EOT

# Establecer la contraseña del root
echo "root:$root_password" | chpasswd

# Crear el nuevo usuario y establecer su contraseña
useradd -m -G wheel -s /bin/bash $username
echo "$username:$user_password" | chpasswd

# Configurar sudo
pacman -S --noconfirm sudo
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Instalar y configurar el bootloader
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

#Instalar diversos paquetes
pacman -S networkmanager nano

#Configurar red
systemctl enable NetworkManager

# Salir del chroot
exit
EOF

# Desmontar las particiones y reiniciar
echo "Desmontando las particiones..."
umount -R /mnt

echo "Instalación completa. Reiniciando..."
reboot
