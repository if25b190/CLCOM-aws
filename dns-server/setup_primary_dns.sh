#!/bin/bash

export BIND9_HOME=/srv/bind9
mkdir -p $BIND9_HOME/config

curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/docker-compose.yml > $BIND9_HOME/docker-compose.yml
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/config/db.10.0.0 > $BIND9_HOME/config/db.10.0.0
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/config/db.nextgen.com > $BIND9_HOME/config/db.nextgen.com
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/config/ns1_named.conf.local > $BIND9_HOME/config/named.conf
cd $BIND9_HOME
docker compose up -d
