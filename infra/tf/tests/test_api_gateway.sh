#!/bin/bash

# This script checks if the API Gateway was created correctly.
# It should be run AFTER you have manually run 'terraform apply'.

# Exit immediately if a command exits with a non-zero status.
set -e

# Fetch the API name from Terraform output.
# The '-raw' flag gives us the clean value without quotes.
EXPECTED_API_NAME=$(terraform output -raw api_name)

echo "Verifying API Gateway with name: $EXPECTED_API_NAME"

# Use the AWS CLI to query for an API Gateway with the expected name.
# The query returns the ID of the matching API.
API_ID=$(aws apigateway get-rest-apis --query "items[?name=='$EXPECTED_API_NAME'].id" --output text)

# Check if the API_ID variable is empty.
if [ -z "$API_ID" ]; then
  echo "----------------------------------------"
  echo "TEST FAILED: API Gateway not found."
  echo "----------------------------------------"
  exit 1
else
  echo "----------------------------------------"
  echo "TEST PASSED: Found API Gateway with ID: $API_ID"
  echo "----------------------------------------"
fi
