FROM rockylinux/rockylinux:8.4
RUN dnf -y install epel-release
RUN dnf -y install nagios supervisor
# php-fpm does not automatically create this directory
RUN mkdir -p /run/php-fpm
COPY supervisord.conf /etc/supervisord.conf
# default configuration file is /etc/supervisord.conf
CMD [ "/usr/bin/supervisord" ]
