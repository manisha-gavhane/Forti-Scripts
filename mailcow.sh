#!/bin/bash
 
apt update -y
hostnamectl set-hostname mail.fphish.com
 
# Installing Docker
apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install docker-ce docker-ce-cli containerd.io -y
 
# Installing docker=compose
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
 
# Installing Mailcow
cd /opt
git clone https://github.com/mailcow/mailcow-dockerized
cd mailcow-dockerized
MAILCOW_HOSTNAME="mail.fphish.com" MAILCOW_TZ="Asia/Kolkata" SKIP_CLAMD=y ./generate_config.sh
 
echo -e "173.243.137.145 \n173.243.137.12" >> /opt/mailcow-dockerized/data/conf/rspamd/custom/ip_wl.map
sed -i 's/,reject_non_fqdn_helo_hostname//' /opt/mailcow-dockerized/data/conf/postfix/master.cf
sed -i "s/enabled = true/enabled = false/" /opt/mailcow-dockerized/data/conf/rspamd/local.d/mx_check.conf
 
# Start all the containers
docker-compose up -d

echo "---------Done----------"
 