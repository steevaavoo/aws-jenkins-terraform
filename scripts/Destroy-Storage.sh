#!/bin/bash

aws s3 rb s3://"$TERRAFORM_BUCKET_NAME" --region "$DEFAULT_REGION" --force
