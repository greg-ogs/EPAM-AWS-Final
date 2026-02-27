#!/bin/bash

# The script will load configuration from a file named 'aws.env'
# in the same directory.
ENV_FILE="aws.env"

source "$ENV_FILE"

read -p "Enter your MFA token code: " TOKEN_CODE

ROLE_SESSION_NAME=${ROLE_SESSION_NAME:-"PC-one"}
DURATION_SECONDS=${DURATION_SECONDS:-3600}

echo "Requesting temporary credentials..."

# Execute the AWS STS Assume Role command and capture the JSON output
JSON_OUTPUT=$(aws sts assume-role \
    --role-arn "$ROLE_ARN" \
    --external-id "$EXTERNAL_ID" \
    --role-session-name "$ROLE_SESSION_NAME" \
    --serial-number "$SERIAL_NUMBER" \
    --duration-seconds "$DURATION_SECONDS" \
    --token-code "$TOKEN_CODE")

# Check if the AWS command was successful
if [ $? -ne 0 ]; then
    echo "Failed to assume role. Please check your credentials and try again."
    exit 1
fi

# Extract credentials using jq
ACCESS_KEY_ID=$(echo "$JSON_OUTPUT" | jq -r '.Credentials.AccessKeyId')
SECRET_ACCESS_KEY=$(echo "$JSON_OUTPUT" | jq -r '.Credentials.SecretAccessKey')
SESSION_TOKEN=$(echo "$JSON_OUTPUT" | jq -r '.Credentials.SessionToken')

# For convenience, also export them if the script is sourced
export AWS_ACCESS_KEY_ID="${ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${SECRET_ACCESS_KEY}"
export AWS_SESSION_TOKEN="${SESSION_TOKEN}"
export AWS_REGION="us-east-1"

# Save the extracted credentials to the .env file for the container
cat <<EOL > .env
AWS_ACCESS_KEY_ID=${ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}
AWS_SESSION_TOKEN=${SESSION_TOKEN}
AWS_REGION=us-east-1
EOL

echo "Credentials have been exported to your shell and saved to .env for container use."
