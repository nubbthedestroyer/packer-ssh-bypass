#!/usr/bin/env bash

set -e

cd terraform
terraform init
terraform destroy -lock=false -auto-approve
rm -rf ./.terraform
cd -