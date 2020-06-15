# borg-backup-service

This is a container image that will run BorgBackup as a service, making automatic backups to a remote host.
The motivation was to be able to specify a backup as part of a docker-compose configuration, enabling automatic backups without dependencies to the host system.

## Usage

### Prerequisites

- Make sure borg is installed on the remote host.
- Create a SSH Key pair and place the public key on the remote host.

### Configure Cron Job

- If the default backup schedule (every day at 1 AM) does not suit you do the following:
    - Clone repository: `git clone https://github.com/muyajil/borg-backup-service.git`
    - Edit `backup_cron` to reflect the cron schedule needed for the backup
    - `docker build -t your_custom_image_name .`

- Use the built image to run the service

### General usage

The service works by mounting some relevant volumes and configuring everything through environment variables:

#### Volumes

- The private SSH key used to connect to the remote host needs to be mounted to some path in the container.
- The backup source needs to be mounted to `/backup`
- Some directory which will contain the borg backup keys should be mounted to some path in the container as well.

#### Environment Variables
- `BORG_USER`: User on remote host
- `BORG_HOST`: Remote host
- `BORG_PORT`: Port on remote host to receive SSH connections
- `BORG_REPO_PATH_ON_HOST`: Borg repository path on host
- `BORG_OPTIONS`: Options of borg command
- `ARCHIVE_NAME`: Name of this borg archive
- `BORG_PASSSPHRASE`: Passphrase for borg repository
- `BORG_KEYS_DIR`: Path to mounted borg keys directory
- `HOURLY_BACKUPS`: Number of hourly backups to keep
- `DAILY_BACKUPS`: Number of daily backups to keep
- `WEEKLY_BACKUPS`: Number of weekly backups to keep
- `SSH_KEY_PATH`: Path to mounted SSH key
- `SLACK_WEBHOOK`: (optional) Webhook to notify if backup failed.

### Docker run command

This is an example docker run command:

`docker run --rm -v /home/user/some_folder:/backup_source -v /home/user/.ssh/id_rsa:/id_rsa -v /home/user/borg_keys:/borg_keys -e BORG_USER=user -e BORG_HOST=some.host -e BORG_PORT=22 -e SSH_KEY_PATH=/id_rsa -e ARCHIVE_NAME=backup_archive -e BORG_OPTIONS="--exclude=/some/exclude/path" -e HOURLY_BACKUPS=1 -e DAILY_BACKUPS=1 -e WEEKLY_BACKUPS=1 -e BORG_PASSPHRASE=somepassphrase -e BORG_KEYS_DIR=/borg_keys -e BORG_REPO_PATH_ON_HOST="~/backup" -e SLACK_WEBHOOK="https://some.slack.webhook" muyajil/borg-backup-service`

### Docker Compose config

This is the same example as a docker-compose configuration:

```
version: "3.5"

services:
  backup:
    image: muyajil/borg-backup-service:latest
    environment:
      BORG_USER: user
      BORG_HOST: some.host
      BORG_PORT: 22
      BORG_REPO_PATH_ON_HOST: "~/backup"
      ARCHIVE_NAME: backup_archive
      BORG_OPTIONS: "--exclude=/some/exclude/path"
      BORG_PASSPHRASE: somepassphrase
      BORG_KEYS_DIR: /borg_keys
      HOURLY_BACKUPS: 1
      DAILY_BACKUPS: 1
      WEEKLY_BACKUPS: 1
      SSH_KEY_PATH: /id_rsa
      SLACK_WEBHOOK: "https://some.slack.webhook"
    volumes:
      - /home/user/some_folder:/backup_source
      - /home/user/.ssh/id_rsa:/id_rsa
      - /home/user/borg_keys:/borg_keys
    restart: unless-stopped

```