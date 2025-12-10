#!/bin/bash

mkdir -p /srv/gitlab
export GITLAB_HOME=/srv/gitlab

fallocate -l 6G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/gitlab-server/gitlab.docker-compose.yml > $GITLAB_HOME/gitlab.docker-compose.yml
cd $GITLAB_HOME
docker compose -f ./gitlab.docker-compose.yml up -d

# docker compose exec -it gitlab-server cat /etc/gitlab/initial_root_password
