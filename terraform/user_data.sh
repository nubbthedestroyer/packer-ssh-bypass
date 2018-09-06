#!/usr/bin/env bash

##
## Setup SSH Config
##
cat <<"__EOF__" > /home/${ssh_user}/.ssh/config
Host *
    StrictHostKeyChecking no
__EOF__
chmod 600 /home/${ssh_user}/.ssh/config
chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh/config

#echo "Port ${ssh_port}" >> /etc/ssh/sshd_config

sed -i "s/Port 22/Port ${ssh_port}/g" /etc/ssh/sshd_config

yes "${ssh_password}" | passwd ${ssh_user}
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
service sshd restart