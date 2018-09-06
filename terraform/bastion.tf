provider "aws" {
  region = "${var.region}"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_security_group" "bastion" {
  name_prefix = "test-sg"
  description = "test-sg"
  vpc_id      = "${aws_default_vpc.default.id}"
}

resource "aws_security_group_rule" "sg_ingress_22" {
  security_group_id = "${aws_security_group.bastion.id}"

  type = "ingress"

  protocol    = "tcp"
  from_port   = "22"
  to_port     = "22"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_ingress_443" {
  security_group_id = "${aws_security_group.bastion.id}"

  type = "ingress"

  protocol    = "tcp"
  from_port   = "443"
  to_port     = "443"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_egress_all" {
  security_group_id = "${aws_security_group.bastion.id}"

  type = "egress"

  protocol    = "All"
  from_port   = "0"
  to_port     = "65535"
  cidr_blocks = ["0.0.0.0/0"]
}

//module "vpc" {
//  source   = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork.git?ref=v0.0.1"
//  vpc_name = "testvpc"
//}
//
//resource "aws_route53_zone" "localzone"{
//  name = "vpc.local"
//  vpc_id = "${module.vpc.vpc_id}"
//}

resource "aws_default_vpc" "default" {}

data "aws_subnet_ids" "subnets" {
  vpc_id = "${aws_default_vpc.default.id}"
}

resource "aws_instance" "default" {
  ami           = "${var.ami}"
  instance_type = "t2.micro"

  user_data = "${data.template_file.user_data.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
  ]

  iam_instance_profile        = "${aws_iam_instance_profile.default.name}"
  associate_public_ip_address = "true"

  key_name  = "${var.ssh_key_name}"
  subnet_id = "${data.aws_subnet_ids.subnets.ids[0]}"

  root_block_device {
    volume_size = "64"
  }

  tags {
    Name = "packer-bastion"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    welcome_message = "Please use responsibly."
    ssh_user        = "${var.bastion_ssh_user}"
    ssh_port        = "${var.bastion_ssh_port}"
    ssh_password    = "${random_string.ssh_password.result}"
  }
}

resource "aws_iam_instance_profile" "default" {
  name_prefix = "temp-bastion"
  role        = "${aws_iam_role.default.name}"
}

resource "aws_iam_role" "default" {
  name_prefix = "temp-bastion"
  path        = "/"

  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "random_string" "ssh_password" {
  length           = 16
  override_special = false
}