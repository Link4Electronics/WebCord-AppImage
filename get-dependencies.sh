#!/bin/sh

set -eu

ARCH=$(uname -m)
case "$ARCH" in # they use AMD64 and ARM64 for the deb links
	x86_64)  deb_arch=x64;;
	aarch64) deb_arch=arm64;;
esac
DEB_LINK="https://github.com/SpacingBat3/WebCord/releases/download/v4.12.1/webcord_4.12.1_$ARCH.deb"

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm pipewire \
    pipewire-jack

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

VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/SpacingBat3/WebCord | tail -n1 | sed 's/.*\///; s/\^{}//; s/^v//')"
echo "$VERSION" > ~/version

ar xvf /tmp/app.deb
tar -xvf ./data.tar.zst
rm -f ./*.gz
mv -v ./usr ./AppDir
cp -v ./AppDir/share/applications/webcord.desktop            ./AppDir
cp -v ./AppDir/share/pixmaps/webcord.png  ./AppDir/.DirIcon
cp -v ./AppDir/share/pixmaps/webcord.png  ./AppDir

#awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
