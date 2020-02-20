FROM centos:7

LABEL authors = "Roy To <roy.anonymous@gmail.com>"

# Install EPEL Repo
RUN yum -y install epel-release
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum -y install nginx supervisor gettext net-tools vim telnet wget unzip \ 
    php72w-cli php72w-common php72w-devel php72w-fpm php72w-gd php72w-mbstring php72w-mysql php72w-opcache php72w-pdo \
    php72w-pear php72w-pecl-igbinary php72w-pecl-memcached php72w-pecl-redis php72w-process php72w-soap php72w-xml \
    php72w-xmlrpc php72w php72w-intl php72w-ldap 

RUN yum clean all

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN rm -f /etc/nginx/sites-enabled/*
COPY nginx.conf.tpl /tmp/nginx.conf.tpl
COPY php-fpm.conf.tpl /tmp/php-fpm.conf.tpl

EXPOSE 80

COPY listener.php /listener.php
COPY supervisor.ini /etc/supervisord.d/supervisor.ini

COPY entrypoint.sh /entrypoint.sh
RUN sed -i -e 's/\r$//' /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]