#!/bin/bash

# Parameters
REPO_NAME=$1
REGION=$2

# Delete the repository with force flag
aws ecr-public delete-repository --repository-name "$REPO_NAME" --region "$REGION" --force

# Check if the repository still exists
REPO_EXISTS=$(aws ecr-public describe-repositories --repository-names "$REPO_NAME" --region "$REGION" 2>&1)

# If the repository does not exist, REPO_EXISTS will contain "RepositoryNotFoundException"
if [[ "$REPO_EXISTS" == *"RepositoryNotFoundException"* ]]; then
  echo "Repository $REPO_NAME successfully deleted."
  exit 0
else
  echo "Failed to delete repository $REPO_NAME."
  exit 1
fi