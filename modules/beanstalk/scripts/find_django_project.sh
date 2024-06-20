#!/bin/bash

# Get the specified path from the argument
DJANGO_APP_PATH=$1

# Find the directory containing settings.py within the specified path
project_dir=$(find "$DJANGO_APP_PATH" -type f -name "settings.py" -exec dirname {} \; | head -n 1)

# Extract the base directory name (project name)
project_name=$(basename "$project_dir")

echo "$project_name"
