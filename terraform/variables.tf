variable "ami" {
  default = "ami-04169656fea786776"
}

variable "ssh_key_name" {
  description = "Enter a keypair name in AWS to use for authentication to the packer build instance (not bastion).  Ensure you have the private key on your machine.  This keypair must already have been created.  See here for details: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair"
}

variable "ssh_user" {
  description = "The username you would like to use to connect to the packer builder (not the bastion). This varies based on the source AMI.  For Ubuntu, its \"ubuntu\" and for Amazon Linux, CentOS, or RedHat its \"ec2-user\".  This skeleton uses Amazon Linux 2 by default so, if in doubt, use \"ec2-user\"."
}

variable "bastion_ssh_port" {
  description = "Port that you would like the bastion to listen for incoming connections on.  This is used in the Packer config as a variable."
  default = "443"
}

variable "bastion_ssh_user" {
  description = "The username of the Bastion server (not the packer source ami).  This should always be ubuntu unless you changed the base AMI of the bastion instance."
  default = "ubuntu"
}