# Nagios Core in a Rocky Linux Container

## Container Images

Built container images available on Docker Hub:

https://hub.docker.com/repository/docker/dhml/nagios

## Docker

```
# build image
docker build -t nagios .

mkdir -p conf logs/{httpd,php-fpm,nagios}
# populate conf dir here

# validate configuration
docker run -it --rm \
-v $(pwd)/conf/config:/etc/nagios \
nagios \
/usr/sbin/nagios -v /etc/nagios/nagios.cfg

# run container
export MSMTP_HOST=relay.example.com
export MSMTP_FROM=noreply@example.com
docker run \
-d \
--env MSMTP_HOST \
--env MSMTP_FROM \
--name nagios \
-p 8080:80 \
--rm \
-v $(pwd)/conf:/etc/nagios \
-v $(pwd)/logs/httpd:/var/log/httpd \
-v $(pwd)/logs/php-fpm:/var/log/php-fpm \
-v $(pwd)/logs/nagios:/var/log/nagios \
nagios

# manage processes
docker exec -it nagios /usr/bin/supervisorctl status
docker exec -it nagios /usr/bin/supervisorctl restart httpd
docker exec -it nagios /usr/bin/supervisorctl restart php-fpm
docker exec -it nagios /usr/bin/supervisorctl restart nagios

# proceed to: http://localhost:8080/nagios
```

## Podman

```
# build image
podman build -t nagios .

mkdir -p conf logs/{httpd,php-fpm,nagios}
# populate conf dir here

# validate configuration
podman run -it --rm \
-v $(pwd)/conf/config:/etc/nagios \
nagios \
/usr/sbin/nagios -v /etc/nagios/nagios.cfg

# run rootless container
export MSMTP_HOST=relay.example.com
export MSMTP_FROM=noreply@example.com
podman run \
--cap-add=CAP_NET_RAW \
-d \
--env MSMTP_HOST \
--env MSMTP_FROM \
--name nagios \
-p 8080:80 \
--rm \
-v $(pwd)/conf:/etc/nagios \
-v $(pwd)/logs/httpd:/var/log/httpd \
-v $(pwd)/logs/php-fpm:/var/log/php-fpm \
-v $(pwd)/logs/nagios:/var/log/nagios \
nagios

# manage processes
podman exec -it nagios /usr/bin/supervisorctl status
podman exec -it nagios /usr/bin/supervisorctl restart httpd
podman exec -it nagios /usr/bin/supervisorctl restart php-fpm
podman exec -it nagios /usr/bin/supervisorctl restart nagios

# proceed to: http://localhost:8080/nagios
```
