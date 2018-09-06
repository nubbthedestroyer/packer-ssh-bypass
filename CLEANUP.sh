#!/usr/bin/env bash

cd terraform
terraform destroy
rm -rf ./.terraform
cd -