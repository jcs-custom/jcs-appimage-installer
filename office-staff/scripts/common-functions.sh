#!/bin/bash

PROJECT_DIR="$(dirname "$(readlink -f "$0")")/.."

LOG_DIR="$PROJECT_DIR/assets/logs"

DATE=$(date +"%Y-%m-%d-%H%M")

LOG_FILE="$LOG_DIR/office-install-$DATE.log"


log()
{
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" | tee -a "$LOG_FILE"
}
