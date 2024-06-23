#!/bin/bash
REPO_NAME=$1
REGION=$2

check_exit_status() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

# Get the list of image digests
image_digests=$(aws ecr-public describe-images --repository-name "$REPO_NAME" --region "$REGION" --query 'imageDetails[*].imageDigest' --output text)
check_exit_status "Failed to retrieve image digests."


# Loop through the list and delete each image
for digest in $image_digests; do
  aws ecr-public batch-delete-image --repository-name "$REPO_NAME" --region "$REGION" --image-ids imageDigest="$digest"
done
check_exit_status "Failed to delete image with digest: $digest"

