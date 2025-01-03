FROM php:8.3.14-fpm-bullseye

LABEL authors = "Roy To <roy.to@itdogsoftware.co>"
# Add nodejs repo
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
# Install library & necessary service
RUN apt-get update && apt-get install -y libzip-dev zip libpng-dev cron supervisor vim nodejs gettext-base nginx && rm -rf /var/lib/apt/lists/*
# Install docker php extensions
RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pcntl
# set production config
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
# enable opcache config
COPY docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
# Update php config
RUN sed -i "/memory_limit\s=\s/s/=.*/= 512M/" /usr/local/etc/php/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN rm -f /etc/nginx/sites-enabled/*
COPY nginx.conf.tpl /tmp/nginx.conf.tpl
COPY zz-docker.conf.tpl /tmp/zz-docker.conf.tpl

EXPOSE 80

COPY listener.php /listener.php
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
RUN sed -i '/^\[supervisord\]/a user=root' /etc/supervisor/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN sed -i -e 's/\r$//' /entrypoint.sh
RUN mkdir /run/supervisor
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]