echo "Creating new backup..."

export BORG_RSH="ssh -i ${SSH_KEY_PATH}"

if borg create ${BORG_OPTIONS} --progress --stats ssh://${BORG_USER}@${BORG_HOST}:${BORG_PORT}/${BORG_REPO_PATH_ON_HOST}::${ARCHIVE_NAME}-$(date +'%Y-%m-%d-%H:%M') /backup_source ; then
  echo "Backup succeeded. Pruning..."
  borg prune --keep-hourly ${HOURLY_BACKUPS} --keep-daily ${DAILY_BACKUPS} --keep-weekly ${WEEKLY_BACKUPS}
  echo "Backup finished."
else
  curl -X POST -H 'Content-type: application/json' --data '{"text":"There was a problem with the backup!"}' ${SLACK_WEBHOOK}
fi