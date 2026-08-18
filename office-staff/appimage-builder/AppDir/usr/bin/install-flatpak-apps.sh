#!/bin/bash

HERE="$(dirname "$(readlink -f "$0")")"
APP_ROOT="$(cd "$HERE/../.." && pwd)"
APP_LIST="$APP_ROOT/payload/application-check-list.txt"

INSTALL_FAILED=0
CURRENT_PID=""

# Flatpak information used for interrupted-install cleanup
INSTALL_BEFORE_SNAPSHOT=""
INSTALL_TARGET_ID=""


# ==================================
# Interrupt handling
# ==================================

cleanup_on_interrupt()
{
    echo ""
    echo "===================================="
    echo " Installation interrupted by user "
    echo "===================================="

    INSTALL_FAILED=1


    # ----------------------------------
    # Stop the active installation
    # ----------------------------------

    if [ -n "$CURRENT_PID" ] && \
       kill -0 "$CURRENT_PID" 2>/dev/null
    then

        echo "Stopping current installation process..."

        kill -TERM "$CURRENT_PID" 2>/dev/null

        # Give the child process a moment to terminate.
        sleep 1


        # If still alive, force termination.
        if kill -0 "$CURRENT_PID" 2>/dev/null
        then

            echo "Installation process did not stop."
            echo "Forcing termination..."

            kill -KILL "$CURRENT_PID" 2>/dev/null

        fi


        wait "$CURRENT_PID" 2>/dev/null

    fi

    CURRENT_PID=""


    # ----------------------------------
    # Clean up interrupted Flatpak
    # installation.
    #
    # Only components that were NOT
    # present before this installation
    # are removed.
    # ----------------------------------

    if [ -n "$INSTALL_BEFORE_SNAPSHOT" ] && \
       [ -n "$INSTALL_TARGET_ID" ]
    then

        echo ""
        echo "Cleaning up interrupted Flatpak installation..."
        echo "Application: $INSTALL_TARGET_ID"


        CURRENT_SNAPSHOT="$(
            flatpak list \
                --columns=application \
                2>/dev/null
        )"


        while IFS= read -r REF
        do

            [ -z "$REF" ] && continue


            # Was this Flatpak reference already
            # present before JCS started installing?
            if printf '%s\n' "$INSTALL_BEFORE_SNAPSHOT" | \
                grep -Fxq "$REF"
            then

                continue

            fi


            # Only remove references belonging to
            # the application being installed.
            if [ "$REF" = "$INSTALL_TARGET_ID" ] || \
               [[ "$REF" == "$INSTALL_TARGET_ID."* ]]
            then

                echo "Removing newly installed component:"
                echo "$REF"

                flatpak uninstall -y "$REF" \
                    >/dev/null 2>&1 || true

            fi

        done <<< "$CURRENT_SNAPSHOT"

    fi


    INSTALL_BEFORE_SNAPSHOT=""
    INSTALL_TARGET_ID=""


    echo ""
    echo "Cleanup completed."
    echo "No background installation will continue."

    exit 130
}


trap cleanup_on_interrupt INT TERM


# ==================================
# Header
# ==================================

echo "===================================="
echo " JCS Office Staff Application Check "
echo "===================================="


# ==================================
# Manifest check
# ==================================

if [ ! -f "$APP_LIST" ]
then

    echo ""
    echo "ERROR: Application manifest not found:"
    echo "$APP_LIST"

    exit 1

fi


# ==================================
# Check Flatpak availability
# ==================================

FLATPAK_AVAILABLE=0

if command -v flatpak >/dev/null 2>&1
then

    FLATPAK_AVAILABLE=1

else

    echo ""
    echo "WARNING: Flatpak is not installed."

fi


# ==================================
# Ensure Flathub
# ==================================

if [ "$FLATPAK_AVAILABLE" -eq 1 ]
then

    if ! flatpak remotes --columns=name | \
        grep -qx "flathub"
    then

        echo ""
        echo "Adding Flathub repository..."

        if ! flatpak remote-add \
            --if-not-exists \
            flathub \
            https://flathub.org/repo/flathub.flatpakrepo
        then

            echo ""
            echo "FAILED:"
            echo "Unable to add Flathub repository."

            exit 1

        fi

    fi

fi


# ==================================
# Process manifest
# ==================================

while IFS="|" read -r NAME FLATPAK SNAP DEB METHOD
do

    [ -z "$NAME" ] && continue


    echo ""
    echo "------------------------------------"
    echo "Checking: $NAME"


    # ==================================
    # Validate installation method
    # ==================================

    case "$METHOD" in

        flatpak|snap|deb)
            ;;

        *)

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Invalid installation method: $METHOD"

            INSTALL_FAILED=1

            continue
            ;;

    esac


    # ==================================
    # GLOBAL INSTALLATION CHECK
    #
    # If the application already exists
    # through ANY supported package system,
    # NEVER install it again.
    # ==================================

    RESULT="$(
        "$HERE/check-installed.sh" \
            "$FLATPAK" \
            "$SNAP" \
            "$DEB"
    )"


    if [ "$RESULT" != "NONE" ]
    then

        echo "Already installed via: $RESULT"
        echo "Skipping: $NAME"

        continue

    fi


    echo "No existing installation detected."
    echo "Required installation method: $METHOD"


    # ==================================
    # STRICT FLATPAK
    # ==================================

    if [ "$METHOD" = "flatpak" ]
    then

        if [ -z "$FLATPAK" ]
        then

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Method is Flatpak but no Flatpak ID is specified."

            INSTALL_FAILED=1

            continue

        fi


        if [ "$FLATPAK_AVAILABLE" -ne 1 ]
        then

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Flatpak is not installed."
            echo "No fallback method will be attempted."

            INSTALL_FAILED=1

            continue

        fi


        echo ""
        echo "Installing Flatpak:"
        echo "$FLATPAK"


        # ----------------------------------
        # Snapshot current Flatpak state
        # BEFORE installation.
        # ----------------------------------

        INSTALL_TARGET_ID="$FLATPAK"

        INSTALL_BEFORE_SNAPSHOT="$(
            flatpak list \
                --columns=application \
                2>/dev/null
        )"


        # ----------------------------------
        # Start Flatpak installation
        # ----------------------------------

        flatpak install -y flathub "$FLATPAK" &

        CURRENT_PID=$!


        wait "$CURRENT_PID"
        STATUS=$?


        CURRENT_PID=""


        # ----------------------------------
        # Successful installation:
        # clear interrupt cleanup data.
        # ----------------------------------

        INSTALL_BEFORE_SNAPSHOT=""
        INSTALL_TARGET_ID=""


        if [ "$STATUS" -eq 0 ]
        then

            echo ""
            echo "SUCCESS:"
            echo "$NAME"

        else

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Method: Flatpak"
            echo "No fallback method will be attempted."

            INSTALL_FAILED=1

        fi


        continue

    fi


    # ==================================
    # STRICT SNAP
    # ==================================

    if [ "$METHOD" = "snap" ]
    then

        if [ -z "$SNAP" ]
        then

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Method is Snap but no Snap ID is specified."

            INSTALL_FAILED=1

            continue

        fi


        if ! command -v snap >/dev/null 2>&1
        then

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Snap is not installed."
            echo "No fallback method will be attempted."

            INSTALL_FAILED=1

            continue

        fi


        echo ""
        echo "Installing Snap:"
        echo "$SNAP"


        sudo snap install "$SNAP" &

        CURRENT_PID=$!


        wait "$CURRENT_PID"
        STATUS=$?


        CURRENT_PID=""


        if [ "$STATUS" -eq 0 ]
        then

            echo ""
            echo "SUCCESS:"
            echo "$NAME"

        else

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Method: Snap"
            echo "No fallback method will be attempted."

            INSTALL_FAILED=1

        fi


        continue

    fi


    # ==================================
    # STRICT DEB
    # ==================================

    if [ "$METHOD" = "deb" ]
    then

        if [ -z "$DEB" ]
        then

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Method is DEB but no DEB package is specified."

            INSTALL_FAILED=1

            continue

        fi


        if ! command -v apt-get >/dev/null 2>&1
        then

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "apt-get is not available."
            echo "No fallback method will be attempted."

            INSTALL_FAILED=1

            continue

        fi


        echo ""
        echo "Installing DEB package:"
        echo "$DEB"


        sudo apt-get install -y "$DEB" &

        CURRENT_PID=$!


        wait "$CURRENT_PID"
        STATUS=$?


        CURRENT_PID=""


        if [ "$STATUS" -eq 0 ]
        then

            echo ""
            echo "SUCCESS:"
            echo "$NAME"

        else

            echo ""
            echo "FAILED:"
            echo "$NAME"
            echo "Method: DEB"
            echo "No fallback method will be attempted."

            INSTALL_FAILED=1

        fi


        continue

    fi


done < "$APP_LIST"


# ==================================
# Final result
# ==================================

echo ""
echo "===================================="


if [ "$INSTALL_FAILED" -eq 0 ]
then

    echo " All applications completed "
    echo "===================================="

    exit 0

else

    echo " Some applications could not be installed "
    echo "===================================="

    exit 1

fi
