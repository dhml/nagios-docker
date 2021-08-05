# Nagios Core in a Docker Container

```
# build image
docker build -t nagios .
# populate conf dir here
# run container
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
# proceed to: http://localhost:8080/nagios
# manage processes
docker exec -it nagios /usr/bin/supervisorctl status
docker exec -it nagios /usr/bin/supervisorctl restart httpd
docker exec -it nagios /usr/bin/supervisorctl restart php-fpm
docker exec -it nagios /usr/bin/supervisorctl restart nagios
```
