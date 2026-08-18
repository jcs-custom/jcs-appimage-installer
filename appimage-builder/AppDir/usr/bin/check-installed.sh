#!/bin/bash

FLATPAK_ID="$1"
SNAP_ID="$2"
DEB_ID="$3"


# Check Flatpak

if [ -n "$FLATPAK_ID" ]; then

    if flatpak list --app --columns=application | grep -q "^$FLATPAK_ID$"
    then
        echo "Flatpak"
        exit 0
    fi

fi


# Check Snap

if [ -n "$SNAP_ID" ]; then

    if snap list "$SNAP_ID" >/dev/null 2>&1
    then
        echo "Snap"
        exit 0
    fi

fi


# Check DEB

if [ -n "$DEB_ID" ]; then

    if dpkg -l "$DEB_ID" 2>/dev/null | grep -q "^ii"
    then
        echo "DEB"
        exit 0
    fi

fi


echo "NONE"
exit 1
