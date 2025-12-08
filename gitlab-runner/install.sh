#!/bin/bash
mkdir -p /srv/gitlab-runner/config

fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/gitlab-runner/config.toml > /srv/gitlab-runner/config/config.toml
curl https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/gitlab-runner/docker-compose.yml > /srv/gitlab-runner/config/docker-compose.yml
cd /srv/gitlab-runner/config
docker compose up -d
