# Docker Nginx, PHP-FPM, Composer, Supervisor container

By using supervisord to maintain Nginx, php-fpm 7 process in Centos 7 with misc utilities, such as composer

## Build

```bash
$ docker build -t local/nginx-php-fpm .
```

## Run

```bash
$ docker run --name test -d -p 8080:80 --rm -it local/nginx-php-fpm
```

## Login to bash
```bash
docker exec -it test /bin/bash
```

## Inspired by Forma-Pro
