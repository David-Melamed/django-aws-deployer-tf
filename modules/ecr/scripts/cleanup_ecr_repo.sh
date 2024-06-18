#!/bin/bash

REPO_NAME=$1
REGION=$2

if [ -z "$REPO_NAME" ] || [ -z "$REGION" ]; then
    echo "Usage: $0 <repository-name> <region>"
    exit 1
fi

echo "Starting cleanup of ECR repository: $REPO_NAME in region: $REGION"

# Get the list of image digests
image_digests=$(aws ecr-public describe-images --repository-name "$REPO_NAME" --region "$REGION" --query 'imageDetails[].imageDigest' --output text)

if [ -z "$image_digests" ]; then
    echo "No images found in the repository $REPO_NAME"
    exit 0
fi

# Delete images by digest
for digest in $image_digests; do
    aws ecr-public batch-delete-image --repository-name "$REPO_NAME" --region "$REGION" --image-ids imageDigest="$digest"
    echo "Deleted image with digest: $digest"
done

echo "All images have been deleted from the repository $REPO_NAME"