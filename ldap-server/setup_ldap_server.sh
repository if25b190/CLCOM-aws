#!/bin/

mkdir -p /srv/ldap
export LDAP_HOME=/srv/ldap

curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/ldap-server/ldap.docker-compose.yml > $LDAP_HOME/ldap.docker-compose.yml
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/ldap-server/ldap-groups.ldif > $LDAP_HOME/ldap-groups.ldif
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/ldap-server/ldap-users.ldif > $LDAP_HOME/ldap-users.ldif
cd $LDAP_HOME
docker compose -f ./ldap.docker-compose.yml up -d