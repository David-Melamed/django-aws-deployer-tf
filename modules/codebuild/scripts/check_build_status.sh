#!/bin/bash

# Parameters
PROJECT_NAME=$1
BUILD_ID=$2

TIMEOUT=300 # 5 minutes timeout in seconds
INTERVAL=30 # Check interval in seconds

# Function to get the build status
get_build_status() {
  aws codebuild batch-get-builds --ids $BUILD_ID --query 'builds[0].buildStatus' --output text 2>&1
}

# Function to check if the image is pushed
is_image_pushed() {
  aws ecr describe-images --repository-name $PROJECT_NAME --image-ids imageTag=latest --query 'imageDetails[0]' --output text 2>&1 | grep -q "imageDigest"
  return $?
}

# Wait for the build to complete or timeout
SECONDS_WAITED=0
BUILD_STATUS=$(get_build_status)
echo "Build status: $BUILD_STATUS" >&2

while [[ $BUILD_STATUS == "IN_PROGRESS" && $SECONDS_WAITED -lt $TIMEOUT ]]; do
  echo "Waiting for build to complete..." >&2
  sleep $INTERVAL
  SECONDS_WAITED=$((SECONDS_WAITED + INTERVAL))
  BUILD_STATUS=$(get_build_status)
  echo "Build status: $BUILD_STATUS" >&2
done

# Check the final build status and if the image is pushed
if [[ $BUILD_STATUS == "SUCCEEDED" && $(is_image_pushed) ]]; then
  echo '{"image_build_status": "true"}'
else
  echo '{"image_build_status": "false"}'
fi
