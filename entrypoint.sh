#!/bin/bash
export NGINX_WEB_ROOT=${NGINX_WEB_ROOT:-'/var/www/html/public'}
export NGINX_PHP_FALLBACK=${NGINX_PHP_FALLBACK:-'/index.php'}
export NGINX_PHP_LOCATION=${NGINX_PHP_LOCATION:-'\.php'}
export NGINX_USER=${NGINX_USER:-'www-data'}
export NGINX_CONF=${NGINX_CONF:-'/etc/nginx/nginx.conf'}
export PHP_SOCK_FILE=${PHP_SOCK_FILE:-'/run/php.sock'}
export PHP_USER=${PHP_USER:-'www-data'}
export PHP_GROUP=${PHP_GROUP:-'www-data'}
export PHP_MODE=${PHP_MODE:-'0660'}
export PHP_FPM_CONF=${PHP_FPM_CONF:-'/usr/local/etc/php-fpm.d/zz-docker.conf'}
zz-docker.conf.tpl
envsubst '${NGINX_WEB_ROOT} ${NGINX_PHP_FALLBACK} ${NGINX_PHP_LOCATION} ${NGINX_USER} ${NGINX_CONF} ${PHP_SOCK_FILE} ${PHP_USER} ${PHP_GROUP} ${PHP_MODE} ${PHP_FPM_CONF}' < /tmp/nginx.conf.tpl > $NGINX_CONF
envsubst '${NGINX_WEB_ROOT} ${NGINX_PHP_FALLBACK} ${NGINX_PHP_LOCATION} ${NGINX_USER} ${NGINX_CONF} ${PHP_SOCK_FILE} ${PHP_USER} ${PHP_GROUP} ${PHP_MODE} ${PHP_FPM_CONF}' < /tmp/zz-docker.conf.tpl > $PHP_FPM_CONF
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf