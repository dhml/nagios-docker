FROM rockylinux/rockylinux:8.4
# install packages
RUN dnf -y install epel-release \
    && \
    dnf -y install \
    bind-utils \
    iproute \
    iputils \
    msmtp \
    nmap \
    nagios \
    nagios-plugins-nrpe \
    nagios-plugins-tcp \
    python3 \
    supervisor \
    which \
    && \
    dnf clean all
# install support for microsoft teams webhooks
RUN curl \
    -L \
    -o /usr/local/bin/notify-teams-requirements.txt \
    -s \
    https://github.com/isaac-galvan/nagios-teams-notify/raw/c75c8ebce6b55cfbcc074962accd564d5d82403e/requirements.txt \
    && \
    pip3 install --no-cache-dir -r /usr/local/bin/notify-teams-requirements.txt \
    && \
    curl \
    -L \
    -o /usr/local/bin/notify-teams.py \
    -s \
    https://github.com/isaac-galvan/nagios-teams-notify/raw/c75c8ebce6b55cfbcc074962accd564d5d82403e/notify-teams.py \
    && \
    chmod a+x /usr/local/bin/notify-teams.py
# php-fpm does not automatically create this directory
RUN mkdir -p /run/php-fpm
# install supervisor configuration
COPY supervisord.conf /etc/supervisord.conf
# install entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
# default configuration file is /etc/supervisord.conf
CMD [ "/usr/bin/supervisord" ]
