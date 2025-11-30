#!/bin/bash
mkdir -p /srv/gitlab-runner/config
cp config.toml /srv/gitlab-runner/config/config.toml
cp docker-compose.yml /srv/gitlab-runner/config/docker-compose.yml
cd /srv/gitlab-runner/config

docker compose up -d
