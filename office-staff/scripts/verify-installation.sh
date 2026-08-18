#!/bin/bash

echo "Checking installed applications..."

echo
echo "Flatpak packages:"
flatpak list

echo
echo "Snap packages:"
snap list

echo
echo "Verification finished."

