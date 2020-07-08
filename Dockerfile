FROM ubuntu:18.04

RUN apt update

# Install requirements
RUN apt install -y \
    borgbackup \
    openssh-client \
    cron \
    curl

COPY backup_script.sh /var/backup_script.sh
RUN chmod +x /var/backup_script.sh

COPY backup_cron /etc/cron.d/backup_cron
RUN chmod +x /etc/cron.d/backup_cron
RUN crontab /etc/cron.d/backup_cron

RUN echo "    ServerAliveInterval 60" >> /etc/ssh/ssh_config
RUN echo "    ServerAliveCountMax 1000" >> /etc/ssh/ssh_config
RUN echo "    TCPKeepAlive yes" >> /etc/ssh/ssh_config
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Setup entrypoint
COPY entrypoint.sh /var/entrypoint.sh
RUN chmod +x /var/entrypoint.sh
ENTRYPOINT [ "/var/entrypoint.sh" ]

CMD ["cron", "-f"]