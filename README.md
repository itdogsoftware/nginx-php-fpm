# Docker Nginx, PHP-FPM, Composer, Supervisor container

By using supervisord to maintain Nginx, php-fpm 8 process in Centos 8 with misc utilities, such as composer

## start minikube
```
minikube start
```

## setup docker-env with posershell
```
powershell
minikube docker-env | Invoke-Expression
```

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
