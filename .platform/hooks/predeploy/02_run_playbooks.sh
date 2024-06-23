#!/bin/bash

# Directory containing Ansible playbooks
PLAYBOOK_DIR="/var/app/staging/.platform/ansible/ec2-security"

# Check if the directory exists
if [ ! -d "$PLAYBOOK_DIR" ]; then
    echo "Playbook directory $PLAYBOOK_DIR does not exist."
    exit 1
fi

# Run all Ansible playbooks in the directory
echo "Running Ansible playbooks in $PLAYBOOK_DIR..."
for playbook in "$PLAYBOOK_DIR"/*.yaml; do
    if [ -f "$playbook" ]; then
        echo "Running playbook $playbook..."
        ansible-playbook -i 127.0.0.1, --connection=local "$playbook"
    else
        echo "No playbook files found in $PLAYBOOK_DIR."
    fi
done

echo "All scripts and playbooks executed."
