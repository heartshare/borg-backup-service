FROM ubuntu:18.04

RUN apt update

# Install borg
RUN apt install -y \
    python3 \
    python3-dev \
    python3-pip \
    python-virtualenv \
    libssl-dev openssl \
    libacl1-dev libacl1 \
    build-essential \
    borgbackup

# Install cron
RUN apt-get install -y cron

COPY backup_script.sh /var/backup_script.sh
RUN chmod +x /var/backup_script.sh

COPY backup_cron /etc/cron.d/backup_cron
RUN chmod +x /etc/cron.d/backup_cron
RUN crontab /etc/cron.d/backup_cron

# Setup entrypoint
COPY entrypoint.sh /var/entrypoint.sh
RUN chmod +x /var/entrypoint.sh
ENTRYPOINT [ "/var/entrypoint.sh" ]

CMD ["cron", "-f"]