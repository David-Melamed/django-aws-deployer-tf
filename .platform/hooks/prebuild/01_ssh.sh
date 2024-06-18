#!/bin/bash

# Define the user and paths for the keys
USER="devops_user"
USER_HOME="/home/$USER"
USER_SSH_DIR="$USER_HOME/.ssh"
LOCAL_KEY_PATH="$USER_SSH_DIR/authorized_keys"  # The authorized_keys file path for devops_user
TEMP_KEY_PATH="/var/app/staging/.platform/ssh/id_rsa.pub"  # Temporary public key path

# Check if the temporary public key exists
if [ ! -f "$TEMP_KEY_PATH" ]; then
    echo "My own public key does not exist: $TEMP_KEY_PATH"
    exit 1
fi

# Ensure the .ssh directory exists and has the right permissions for devops_user
sudo useradd -m $USER
sudo -u $USER mkdir -p "$USER_SSH_DIR"
sudo chown $USER:$USER "$USER_SSH_DIR"
sudo chmod 700 "$USER_SSH_DIR"

# Ensure the authorized_keys file exists and has the right permissions for devops_user
if [ ! -f "$LOCAL_KEY_PATH" ]; then
    sudo -u $USER touch "$LOCAL_KEY_PATH"
fi
sudo chown $USER:$USER "$LOCAL_KEY_PATH"
sudo chmod 600 "$LOCAL_KEY_PATH"

# Append the public key from the temporary location to the authorized_keys file
sudo -u $USER bash -c "cat $TEMP_KEY_PATH >> $LOCAL_KEY_PATH"

# Verify the key was copied successfully
if sudo -u $USER grep -qxF -f "$TEMP_KEY_PATH" "$LOCAL_KEY_PATH"; then
    echo "SSH public key deployment completed, you are now able to connect to the server via SSH."
    # Optionally, clean up the temporary file
    sudo rm "$TEMP_KEY_PATH"
else
    echo "Failed to deploy the SSH public key."
    exit 1
fi