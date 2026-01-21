#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm nss \
    pipewire-jack

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#if [ "$ARCH" = 'x86_64' ]; then
make-aur-package electron39-bin
#else
#usermod -p '*' nobody
#chage -E -1 -m 0 -M 99999 -I -1 nobody
#echo "nobody ALL=(ALL) NOPASSWD: /usr/bin/pacman" >> /etc/sudoers
# If the application needs to be manually built that has to be done down here
#git clone https://aur.archlinux.org/electron39-bin.git
#chown -R nobody:nobody electron39-bin
#cd electron39-bin
#sudo -u nobody makepkg -si --noconfirm
#fi
