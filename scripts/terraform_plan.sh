#!/bin/bash

cd ./terraform
terraform plan -out=tfplan
cd ..
