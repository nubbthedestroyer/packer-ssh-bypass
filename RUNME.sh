#!/usr/bin/env bash

set -e

#export AWS_ACCESS_KEY_ID=`aws configure get default.aws_access_key_id`
#export AWS_SECRET_ACCESS_KEY=`aws configure get default.aws_secret_access_key`
#export AWS_DEFAULT_REGION=`aws configure get default.region`

# Apply the terraform
cd terraform
terraform init
terraform apply -lock=false -auto-approve

# Grab terraform outputs
export PACKER_BASTION_IP=`terraform output bastion_ip_address`
export PACKER_AWS_REGION=`terraform output aws_region`
export PACKER_SSH_USER=`terraform output ssh_user`
export PACKER_BASTION_PORT=`terraform output bastion_ssh_port`
export PACKER_BASTION_SSH_USER=`terraform output bastion_ssh_user`
export PACKER_BASTION_SSH_PASSWORD=`terraform output bastion_ssh_password`
export PACKER_SSH_KEY_NAME=`terraform output ssh_key_name`
export PACKER_SSH_PASSWORD=`terraform output bastion_ssh_password`
export PACKER_DEFAULT_AMI=`terraform output default_ami`
cd -

echo ${PACKER_BASTION_IP}
echo ${PACKER_AWS_REGION}
echo ${PACKER_SSH_USER}
echo ${PACKER_BASTION_PORT}
echo ${PACKER_SSH_KEY_NAME}
echo ${PACKER_SSH_PASSWORD}

# Build packer image
cd packer

rm -rf packerlog.txt

export PACKER_LOG=1
export PACKER_LOG_PATH="packerlog.txt"

packer build \
    -var "packer_bastion_ip=${PACKER_BASTION_IP}" \
    -var "packer_bastion_port=${PACKER_BASTION_PORT}" \
    -var "packer_bastion_ssh_user=${PACKER_BASTION_SSH_USER}" \
    -var "packer_bastion_ssh_password=${PACKER_BASTION_SSH_PASSWORD}" \
    -var "packer_aws_region=${PACKER_AWS_REGION}" \
    -var "packer_ssh_user=${PACKER_SSH_USER}" \
    -var "packer_ssh_key_name=${PACKER_SSH_KEY_NAME}" \
    -var "packer_source_ami=${PACKER_DEFAULT_AMI}" \
    -var-file vars.json \
    packer.json

cd -