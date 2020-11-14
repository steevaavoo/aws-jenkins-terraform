#!/bin/bash

cd ./terraform
terraform apply -auto-approve "tfplan"
cd ..
