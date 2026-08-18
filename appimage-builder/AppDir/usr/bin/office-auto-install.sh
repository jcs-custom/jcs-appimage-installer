#!/bin/bash

# ==========================================
# JCS Office Staff Auto Installer
# ==========================================

HERE="$(dirname "$(readlink -f "$0")")"

INSTALL_FAILED=0
CURRENT_PID=""

# ==========================================
# Interrupt handling
# ==========================================

cleanup_on_interrupt()
{
    echo ""
    echo "===================================="
    echo " Installation interrupted by user "
    echo "===================================="

    # --------------------------------------
    # Stop active child process if any
    # --------------------------------------

    if [ -n "$CURRENT_PID" ] && \
       kill -0 "$CURRENT_PID" 2>/dev/null
    then

        echo "Stopping current installation process..."

        kill -TERM "$CURRENT_PID" 2>/dev/null

        # Give the child process a moment
        # to terminate normally.
        sleep 1

        # ----------------------------------
        # Force termination if necessary
        # ----------------------------------

        if kill -0 "$CURRENT_PID" 2>/dev/null
        then

            echo "Installation process did not stop."
            echo "Forcing termination..."

            kill -KILL "$CURRENT_PID" 2>/dev/null

        fi

        wait "$CURRENT_PID" 2>/dev/null

    fi

    CURRENT_PID=""

    echo ""
    echo "No further applications will be installed."
    echo "No background installation will continue."

    exit 130
}

trap cleanup_on_interrupt INT TERM


# ==========================================
# Header
# ==========================================

echo "===================================="
echo " JCS Office Staff Auto Installer "
echo "===================================="


# ==========================================
# Stage 1
# ==========================================

echo ""
echo "[1/2] Installing Flatpak applications..."

"$HERE/install-flatpak-apps.sh"
STATUS=$?


# ==========================================
# IMPORTANT:
#
# Exit code 130 means the user pressed
# Ctrl+C / the installation was interrupted.
#
# NEVER continue to Stage 2.
# ==========================================

if [ "$STATUS" -eq 130 ]
then

    echo ""
    echo "===================================="
    echo " Installation stopped by user "
    echo "===================================="
    echo ""
    echo "No further installation stages will run."
    echo "No background installation will continue."

    exit 130

fi


# ==========================================
# Other Flatpak failure
# ==========================================

if [ "$STATUS" -ne 0 ]
then

    INSTALL_FAILED=1

    echo ""
    echo "Flatpak installation stage FAILED."

fi


# ==========================================
# Stage 2
# ==========================================

echo ""
echo "[2/2] Installing special applications..."

"$HERE/install-special-apps.sh"
STATUS=$?


# ==========================================
# IMPORTANT:
#
# If special applications were interrupted,
# terminate the entire installer.
# ==========================================

if [ "$STATUS" -eq 130 ]
then

    echo ""
    echo "===================================="
    echo " Installation stopped by user "
    echo "===================================="
    echo ""
    echo "No further installation stages will run."
    echo "No background installation will continue."

    exit 130

fi


# ==========================================
# Other special-app failure
# ==========================================

if [ "$STATUS" -ne 0 ]
then

    INSTALL_FAILED=1

    echo ""
    echo "Special application installation stage FAILED."

fi


# ==========================================
# Final result
# ==========================================

echo ""
echo "===================================="

if [ "$INSTALL_FAILED" -eq 0 ]
then

    echo " Installation completed successfully "
    echo "===================================="

    exit 0

else

    echo " Installation completed with errors "
    echo "===================================="

    exit 1

fi
