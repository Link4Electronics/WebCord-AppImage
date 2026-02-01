#!/bin/sh

set -eu

ARCH=$(uname -m)
DEB_LINK="https://github.com/SpacingBat3/WebCord/releases/download/latest/webcord_4.12.1_$ARCH.deb"

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm nss \
    pipewire-jack \
    pipewire

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here

echo "Getting app..."
echo "---------------------------------------------------------------"
if ! wget --retry-connrefused --tries=30 "$DEB_LINK" -O /tmp/app.deb 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

ar xvf /tmp/app.deb
tar -xvf ./data.tar.gz
rm -f ./*.gz
mv -v ./usr ./AppDir
cp -v ./AppDir/share/applications/webcord.desktop            ./AppDir
cp -v ./AppDir/share/pixmaps/webcord.png  ./AppDir/.DirIcon
cp -v ./AppDir/share/pixmaps/webcord.png  ./AppDir

awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
