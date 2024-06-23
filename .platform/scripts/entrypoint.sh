#!/bin/bash

max_retries=20
retry_interval=60

# Function to execute command with retries
run_with_retry() {
    local cmd="$1"
    local retries=0
    local exit_code=1
    
    while [[ $retries -lt $max_retries && $exit_code -ne 0 ]]; do
        ((retries++))
        echo "Attempting command: $cmd (Attempt $retries)"
        $cmd
        exit_code=$?
        if [[ $exit_code -ne 0 && $retries -lt $max_retries ]]; then
            echo "Command failed. Retrying in $retry_interval seconds..."
            sleep $retry_interval
        fi
    done
    
    if [[ $exit_code -ne 0 ]]; then
        echo "Command failed after $max_retries attempts: $cmd"
    fi
}

echo "Starting entrypoint.sh script"

# Commands to run Django application
django_commands=(
    "python manage.py makemigrations"
    "python manage.py migrate"
    "python manage.py runserver 0.0.0.0:9090"
)

# Execute Django commands with retry
for cmd in "${django_commands[@]}"; do
    echo "Running command: $cmd"
    run_with_retry "$cmd"
    echo "Finished command: $cmd"
done

echo "Completed entrypoint.sh script"
