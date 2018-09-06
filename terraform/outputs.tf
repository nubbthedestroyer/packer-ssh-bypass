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
  value = "${var.ssh_key_name}"
}

