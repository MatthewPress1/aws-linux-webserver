#!/bin/bash

apt update
apt install -y apache2
snap install --classic certbot
ln -s /snap/bin/certbot /usr/local/bin/certbot
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable
sed -i 's/#\?PermitRootLogin [a-zA-Z-]*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#\?PasswordAuthentication [a-zA-Z-]*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh
