#!/bin/bash

APP_LIST="$(dirname "$0")/../source/manifests/flatpak-list.txt"

echo "===================================="
echo " JCS Office Staff Flatpak Installer "
echo "===================================="

while read APP
do

if [ -z "$APP" ]; then
    continue
fi

echo ""
echo "Installing: $APP"

flatpak install -y flathub "$APP"

done < "$APP_LIST"


echo ""
echo "Flatpak installation completed."
