#!/bin/

mkdir -p /srv/ldap
export LDAP_HOME=/srv/ldap

curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/ldap-server/ldap.docker-compose.yml >> $LDAP_HOME/ldap.docker-compose.yml
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/ldap-server/gitlab-admin.ldif >> $LDAP_HOME/gitlab-admin.ldif
cd $LDAP_HOME
docker compose -f ./ldap.docker-compose.yml up