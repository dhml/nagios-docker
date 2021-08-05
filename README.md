# Nagios Core in a Docker Container

```
# build image
docker build -t nagios .

# populate conf dir here

# run container in docker
docker run \
-d \
--name nagios \
-p 8080:80 \
--rm \
-v $(pwd)/conf:/etc/nagios \
-v $(pwd)/logs/httpd:/var/log/httpd \
-v $(pwd)/logs/php-fpm:/var/log/php-fpm \
-v $(pwd)/logs/nagios:/var/log/nagios \
nagios

# run container in rootless podman
mkdir -p conf logs/{httpd,php-fpm,nagios}
podman run \
--cap-add=CAP_NET_RAW \
-d \
--name nagios \
-p 8080:80 \
--rm \
-v $(pwd)/conf:/etc/nagios \
-v $(pwd)/logs/httpd:/var/log/httpd \
-v $(pwd)/logs/php-fpm:/var/log/php-fpm \
-v $(pwd)/logs/nagios:/var/log/nagios \
docker://dhml/nagios:8e265f64c90d

# proceed to: http://localhost:8080/nagios

# manage processes
docker exec -it nagios /usr/bin/supervisorctl status
docker exec -it nagios /usr/bin/supervisorctl restart httpd
docker exec -it nagios /usr/bin/supervisorctl restart php-fpm
docker exec -it nagios /usr/bin/supervisorctl restart nagios
```
