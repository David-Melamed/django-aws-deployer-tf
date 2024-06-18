#!/bin/bash

# Check if all arguments are provided
if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <ecr-repository-url> <tag> <new-tag> <path> <platform> <django_repo_url>"
    exit 1
fi

# Define variables from arguments for clarity
APP_NAME="$1"
TAG="$2"
ECR_URI="$3"
PATH_TO_DOCKERFILE="$4"
DOCKER_DEFAULT_PLATFORM="$5"
REPO_URL="$6"

# Clone the repository and change directory
rm -rf django-app
mkdir django-app && cd django-app

if ! git clone "$REPO_URL"; then
    echo "Failed to clone repository."
    exit 1
fi

REPO_NAME=$(basename "$REPO_URL" .git)

# Navigate to the specific directory and build Docker image
cd "$REPO_NAME"
if [ -d "$PATH_TO_DOCKERFILE" ]; then
    docker build --platform "$DOCKER_DEFAULT_PLATFORM" -t "$APP_NAME:$TAG" "$PATH_TO_DOCKERFILE" 
else
    echo "Directory '$PATH_TO_DOCKERFILE' does not exist."
    exit 1
fi

# Tag the Docker image
if ! docker tag "$APP_NAME:$TAG" "$ECR_URI:$TAG"; then
    echo "Failed to tag Docker image."
    exit 1
fi

echo "Docker image built and tagged successfully."