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
if [ "$ARCH" = 'x86_64' ]; then
make-aur-package --chaotic-aur webcord
else
make-aur-package electron39-bin
fi
# If the application needs to be manually built that has to be done down here
