#!/usr/bin/env bash

cd terraform
terraform destroy -lock=false -auto-approve
rm -rf ./.terraform
cd -