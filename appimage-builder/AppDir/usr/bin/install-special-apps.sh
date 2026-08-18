#!/bin/bash

INSTALL_FAILED=0
CURRENT_PID=""
TEMP_DIR=""

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
    # Stop active child process
    # --------------------------------------

    if [ -n "$CURRENT_PID" ] && kill -0 "$CURRENT_PID" 2>/dev/null
    then
        echo "Stopping current installation process..."

        kill -TERM "$CURRENT_PID" 2>/dev/null

        sleep 1

        if kill -0 "$CURRENT_PID" 2>/dev/null
        then
            echo "Installation process did not stop."
            echo "Forcing termination..."

            kill -KILL "$CURRENT_PID" 2>/dev/null
        fi

        wait "$CURRENT_PID" 2>/dev/null
    fi

    CURRENT_PID=""

    # --------------------------------------
    # Remove temporary downloaded files
    # --------------------------------------

    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]
    then
        echo ""
        echo "Removing temporary installation files..."

        rm -rf "$TEMP_DIR"
    fi

    TEMP_DIR=""

    echo ""
    echo "Cleanup completed."
    echo "No background installation will continue."

    exit 130
}

trap cleanup_on_interrupt INT TERM


# ==========================================
# Header
# ==========================================

echo "===================================="
echo " JCS Office Special Applications "
echo "===================================="


# ==========================================
# Stirling-PDF
# STRICT METHOD: Official DEB
# ==========================================

echo ""
echo "Checking: Stirling-PDF"


if dpkg-query -W -f='${Status}' stirling-pdf 2>/dev/null | \
    grep -q "install ok installed"
then

    echo "Already installed via: DEB"
    echo "Skipping: Stirling-PDF"

else

    echo "No existing Stirling-PDF installation detected."
    echo "Installation method: DEB"

    TEMP_DIR="$(mktemp -d)"
    INSTALLER="$TEMP_DIR/linux-installer.deb"

    echo "Downloading official installer..."

    wget -q --show-progress \
        -O "$INSTALLER" \
        https://files.stirlingpdf.com/linux-installer.deb &

    CURRENT_PID=$!

    wait "$CURRENT_PID"
    STATUS=$?

    CURRENT_PID=""

    if [ "$STATUS" -eq 0 ]
    then

        echo ""
        echo "Download successful."
        echo "Installing Stirling-PDF..."

        sudo dpkg -i "$INSTALLER" &

        CURRENT_PID=$!

        wait "$CURRENT_PID"
        STATUS=$?

        CURRENT_PID=""

        if [ "$STATUS" -eq 0 ]
        then

            echo ""
            echo "SUCCESS:"
            echo "Stirling-PDF"

        else

            echo ""
            echo "FAILED:"
            echo "Stirling-PDF"
            echo "Method: DEB"

            INSTALL_FAILED=1
        fi

    else

        echo ""
        echo "FAILED:"
        echo "Stirling-PDF"
        echo "Unable to download official DEB."

        INSTALL_FAILED=1
    fi

    rm -rf "$TEMP_DIR"
    TEMP_DIR=""

fi


# ==========================================
# Wireguird GUI
# STRICT METHOD: Snap
# ==========================================

echo ""
echo "Checking: Wireguird GUI"


if snap list wireguird >/dev/null 2>&1
then

    echo "Already installed via: Snap"
    echo "Skipping: Wireguird GUI"

else

    echo "No existing Wireguird installation detected."
    echo "Installation method: Snap"

    if ! command -v snap >/dev/null 2>&1
    then

        echo ""
        echo "FAILED:"
        echo "Wireguird GUI"
        echo "Snap is not installed."
        echo "No fallback method will be attempted."

        INSTALL_FAILED=1

    else

        echo ""
        echo "Installing Wireguird GUI..."

        sudo snap install wireguird &

        CURRENT_PID=$!

        wait "$CURRENT_PID"
        STATUS=$?

        CURRENT_PID=""

        if [ "$STATUS" -eq 0 ]
        then

            echo ""
            echo "SUCCESS:"
            echo "Wireguird GUI"

        else

            echo ""
            echo "FAILED:"
            echo "Wireguird GUI"
            echo "Method: Snap"
            echo "No fallback method will be attempted."

            INSTALL_FAILED=1
        fi

    fi

fi


# ==========================================
# Final result
# ==========================================

echo ""
echo "===================================="


if [ "$INSTALL_FAILED" -eq 0 ]
then

    echo " Special applications completed "
    echo "===================================="

    exit 0

else

    echo " Special applications have errors "
    echo "===================================="

    exit 1

fi
