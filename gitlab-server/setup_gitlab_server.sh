#!/bin/

mkdir -p /srv/gitlab
export GITLAB_HOME=/srv/gitlab

curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/gitlab-server/gitlab.docker-compose.yml >> $GITLAB_HOME/gitlab.docker-compose.yml
cd $GITLAB_HOME
docker compose -d -f ./gitlab.docker-compose.yml up
