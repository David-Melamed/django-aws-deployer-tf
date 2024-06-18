#!/bin/bash

# Check input arguments
if [ "$#" -ne 3 ]; then
    echo "{\"encrypted_text\":\"\"}"  # Output an empty JSON response
    exit 0
fi

KEY_ID=$1
PLAINTEXT=$2
REGION=$3

# Validate inputs
if [ -z "$KEY_ID" ] || [ -z "$PLAINTEXT" ] || [ -z "$REGION" ]; then
    echo "{\"encrypted_text\":\"\"}"  # Output an empty JSON response
    exit 0
fi

# Set AWS CLI default region
export AWS_DEFAULT_REGION=$REGION

# Perform the encryption
ENCRYPTED_TEXT=$(aws kms encrypt --key-id "$KEY_ID" --plaintext "$PLAINTEXT" --region "$REGION" --output text --query CiphertextBlob 2>&1)

# Check if the encryption was successful
if [ $? -ne 0 ]; then
    echo "{\"encrypted_text\":\"\"}"  # Output an empty JSON response
    exit 1
else
    echo "{\"encrypted_text\":\"$ENCRYPTED_TEXT\"}"
fi