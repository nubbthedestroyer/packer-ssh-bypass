output "bastion_ip_address" {
  value = "${aws_instance.default.public_ip}"
}

output "bastion_ssh_user" {
  value = "${var.bastion_ssh_user}"
}

output "bastion_ssh_password" {
  value = "${random_string.ssh_password.result}"
}

output "bastion_ssh_port" {
  value = "${var.bastion_ssh_port}"
}

output "default_ami" {
  value = "${data.aws_ami.default_build_ami.id}"
}

output "aws_region" {
  value = "${data.aws_region.current.name}"
}

output "ssh_user" {
  value = "${var.ssh_user}"
}

output "ssh_key_name" {
  value = "${var.ssh_key_name != "" ? var.ssh_key_name : var.tmp_keypair_name}"
}

output "builder_connect_command" {
  description = "You can use this command to connect to the Packer instance if you enable -debug and intercept it before the instance is terminated.  See here for more details: https://www.packer.io/docs/builders/amazon-ebs.html#accessing-the-instance-to-debug"
  value = "ssh -o ProxyCommand='ssh -W %h:%p ${var.bastion_ssh_user}:${random_string.ssh_password.result}@${aws_instance.default.public_ip} -p 443' ${var.ssh_user}@<builder-ip> -p 22"
}