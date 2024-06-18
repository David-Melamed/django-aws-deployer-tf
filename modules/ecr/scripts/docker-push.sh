#!/bin/bash
# Login to AWS ECR and push the image

# Environment variables (can be set outside or directly in the script)
REGION=${REGION:-$1}
REPOSITORY_URI=${REPOSITORY_URI:-$2}
IMAGE_TAG=${IMAGE_TAG:-$3}

echo "Logging into AWS ECR with region: $REGION and repository URI: $REPOSITORY_URI"
LOGIN_OUTPUT=$(aws ecr-public get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REPOSITORY_URI" 2>&1)
echo "$LOGIN_OUTPUT"

if echo "$LOGIN_OUTPUT" | grep -q "Login Succeeded"; then
    echo "AWS login succeeded."
else
    echo "Error: AWS login failed."
    echo "Detailed output: $LOGIN_OUTPUT"
    exit 2
fi

echo "Pushing Docker image $REPOSITORY_URI:$IMAGE_TAG to ECR"
PUSH_OUTPUT=$(docker push "$REPOSITORY_URI:$IMAGE_TAG" 2>&1)
echo "$PUSH_OUTPUT"

# Check if the Docker push was successful by looking for a digest string in the output
if echo "$PUSH_OUTPUT" | grep -q "digest: sha256:"; then
    echo "Docker image pushed successfully."
else
    echo "Error: Failed to push Docker image."
    echo "Detailed output: $PUSH_OUTPUT"
    exit 3
fi