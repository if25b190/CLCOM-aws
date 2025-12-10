#!/bin/bash

export BIND9_HOME=/srv/bind9
mkdir -p $BIND9_HOME/config

curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/docker-compose.yml > $BIND9_HOME/docker-compose.yml
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/config/db.10.0.0 > $BIND9_HOME/config/db.10.0.0
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/config/db.nextgen.com > $BIND9_HOME/config/db.nextgen.com
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/config/ns2_named.conf.local > $BIND9_HOME/config/named.conf
cd $BIND9_HOME
docker image pull ubuntu/bind9:latest

cp /etc/systemd/resolved.conf /etc/systemd/resolved.conf.bak
echo 'DNSStubListener=no' | tee -a /etc/systemd/resolved.conf
systemctl restart systemd-resolved.service

docker compose up -d
