#!/bin/bash

# Passing env vars via -backend-config args since they don't work when called
# referenced inside the providers.tf file
# https://github.com/hashicorp/terraform/issues/13022
cd ./terraform
terraform init -backend-config="bucket=$TERRAFORM_BUCKET_NAME" \
               -backend-config="region=$DEFAULT_REGION"
cd ..
