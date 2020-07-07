#!/bin/bash
set -eo pipefail
shopt -s nullglob

export BORG_RSH="ssh -i ${SSH_KEY_PATH}"
export BORG_REPO=ssh://${BORG_USER}@${BORG_HOST}:${BORG_PORT}/${BORG_REPO_PATH_ON_HOST}
if borg init -e keyfile-blake2 ; then
  echo "Backup repository initialized!"
else
  echo "Backup repository already exists!"
fi

# Make env variables accessible in crontab
declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

# Run initial backup
source /var/backup_script.sh

exec "$@"