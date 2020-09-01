FROM centos:8

LABEL authors = "Roy To <roy.to@itdogsoftware.co>"

# Install EPEL Repo
RUN yum -y install epel-release

RUN yum -y install nginx supervisor gettext net-tools vim telnet wget unzip \ 
    php-cli php-common php-devel php-fpm php-gd php-mbstring php-mysqlnd php-opcache php-pdo \
    php-process php-soap php-xml php-xmlrpc \
    php-pecl-zip php php-json php-pear

RUN yum clean all

RUN sed -i "/opcache.huge_code_pages=/s/=.*/=0/" /etc/php.d/10-opcache.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN rm -f /etc/nginx/sites-enabled/*
COPY nginx.conf.tpl /tmp/nginx.conf.tpl
COPY php-fpm.conf.tpl /tmp/php-fpm.conf.tpl

EXPOSE 80

COPY listener.php /listener.php
COPY supervisor.ini /etc/supervisord.d/supervisor.ini
RUN sed -i '/^\[supervisord\]/a user=root' /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN sed -i -e 's/\r$//' /entrypoint.sh
RUN mkdir /run/supervisor
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]