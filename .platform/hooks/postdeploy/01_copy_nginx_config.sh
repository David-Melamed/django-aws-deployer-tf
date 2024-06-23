#!/bin/bash

# Define the source and destination directories
SOURCE_DIR="/var/app/current/.platform/nginx/"
DEST_DIR="/etc/nginx/"

# Function to log messages with timestamps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR: Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Attempt to copy the files
log "Starting to copy files from $SOURCE_DIR to $DEST_DIR"
cp -r ${SOURCE_DIR}* ${DEST_DIR}
if [ $? -eq 0 ]; then
    log "Files copied successfully."
else
    log "ERROR: Failed to copy files."
    exit 1
fi

log "Script completed."