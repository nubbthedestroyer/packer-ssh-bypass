#!/usr/bin/env bash

set -e

cd packer

if [ -f *.pem ]; then
    tmp_keypair_name=`ls | grep packer-keypair | head -1 | sed 's/.pem//g'`
fi

cd -

cd terraform
terraform init
terraform destroy -var "tmp_keypair_name=${tmp_keypair_name}" -lock=false -auto-approve
rm -rf ./.terraform
cd -

cd packer
aws ec2 delete-key-pair --key-name ${tmp_keypair_name} || true
rm -rf *.pem
rm -rf packerlog.txt
cd -