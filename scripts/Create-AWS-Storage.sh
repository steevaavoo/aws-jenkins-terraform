#!/bin/bash
bucket_name="$TERRAFORM_BUCKET_NAME"
# Checking if my bucket already exists and adding result to variable
bucket_exists=$(aws s3api list-buckets --query 'Buckets[?starts_with(Name, `'"$bucket_name"'`) == `true`].Name' --output text)

# Evaluating variable and creating a bucket if empty (-n denotes non-empty)
if [[ -n "$bucket_exists" ]]; then
    echo "Bucket exists, moving on."
else
    echo "Bucket does not exist, creating..."
    aws s3 mb s3://"$TERRAFORM_BUCKET_NAME" --region "$DEFAULT_REGION"
fi
