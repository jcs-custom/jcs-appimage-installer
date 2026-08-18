#!/bin/bash

PROJECT_DIR="$(dirname "$(readlink -f "$0")")/.."

echo "================================="
echo " JCS Office Staff Auto Installer "
echo "================================="

echo
echo "[1/3] Installing Flatpak applications..."
"$PROJECT_DIR/scripts/install-flatpak-apps.sh"

echo
echo "[2/3] Installing special applications..."
"$PROJECT_DIR/scripts/install-special-apps.sh"

echo
echo "[3/3] Verification..."
"$PROJECT_DIR/scripts/verify-installation.sh"

echo
echo "================================="
echo " Installation Completed "
echo "================================="
