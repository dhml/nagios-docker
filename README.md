# Nagios Core in a Rocky Linux Container

## Build the Image

Build and push the image to [Docker
Hub](https://hub.docker.com/repository/docker/dhml/nagios):

```
docker build -t dhml/nagios:$(git rev-parse --short=12 HEAD) .
docker tag dhml/nagios:$(git rev-parse --short=12 HEAD) dhml/nagios:latest
docker push dhml/nagios:$(git rev-parse --short=12 HEAD)
docker push dhml/nagios:latest
```

## Configure Nagios

Modify the contents of the `conf/` directory accordingly.  The contents
here are those present by default after installing the `nagios` package
in the [Rocky Linux 8.4
container](https://hub.docker.com/layers/rockylinux/rockylinux/8.4/images/sha256-f0d7460b97156f6c8ea2ae73152bc11fe410d272387d60ddff36dfcea22ef689).

## Validate Nagios Configuration

```
docker run -it --rm \
-v $(pwd)/conf:/etc/nagios \
dhml/nagios:latest \
/usr/sbin/nagios -v /etc/nagios/nagios.cfg
```

## Sending Nagios Alerts via E-mail

This is handled by [msmtp](https://marlam.de/msmtp/) in the container.
Environment variables `MSMTP_HOST` (the
[host](https://marlam.de/msmtp/msmtp.html#host) to relay mail to) and
`MSMTP_FROM` (the envelope
[from](https://marlam.de/msmtp/msmtp.html#from) address) may be
optionally set when running the container.  If both of these are set,
the system-wide configuration file `/etc/msmtprc` will be written
allowing alert e-mail to be relayed.  See the [msmtp
documentation](https://marlam.de/msmtp/msmtp.html) for details.  Note
that SMTP authentication is not yet supported.

## Run Container in Docker

```
export MSMTP_HOST=relay.example.com
export MSMTP_FROM=noreply@nagios.example.com
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
dhml/nagios:latest
```

Proceed to: http://localhost:8080/nagios/ .  The default username and
password are both `nagiosadmin`.

## Run Rootless Container in Podman

```
export MSMTP_HOST=relay.example.com
export MSMTP_FROM=noreply@nagios.example.com
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
docker://dhml/nagios
```

Proceed to: http://localhost:8080/nagios/ .  The default username and
password are both `nagiosadmin`.

## Manage Nagios Services

```
docker exec -it nagios /usr/bin/supervisorctl status
docker exec -it nagios /usr/bin/supervisorctl restart httpd
docker exec -it nagios /usr/bin/supervisorctl restart php-fpm
docker exec -it nagios /usr/bin/supervisorctl restart nagios
```
