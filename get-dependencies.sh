#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm #PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
if [ "$ARCH" = 'x86_64' ]; then
make-aur-package electron39-bin
else
# If the application needs to be manually built that has to be done down here
git clone https://aur.archlinux.org/electron39-bin.git
cd electron39-bin
# Fix the duplicate aarch64 entry in the PKGBUILD
#sed -i '/^arch=(/ s/\x27aarch64\x27//2' PKGBUILD
makepkg -si --noconfirm
#MAKEPKG_ALLOW_ROOT=1 makepkg -si --noconfirm
fi
