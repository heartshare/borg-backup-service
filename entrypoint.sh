#!/bin/bash
set -eo pipefail
shopt -s nullglob

echo "Host *" >> ~/.ssh/config
echo "    StrictHostKeyChecking no" >> ~/.ssh/config

echo "${SSH_KEY}" >> ~/.ssh/id_rsa

# Make env variables accessible in crontab
declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

exec "$@"