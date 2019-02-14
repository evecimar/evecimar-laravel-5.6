#Desenvolvido por Evecimar Silva - evecimar.com @evecimar
FROM alpine:3.7

ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update add ca-certificates
RUN echo "@php https://php.codecasts.rocks/v3.7/php-7.2" >> /etc/apk/repositories
RUN apk add --update php7@php
RUN apk add --update php7-mbstring@php

RUN apk update && \
    apk add nginx git bash ca-certificates s6 curl ssmtp libzip-dev libwebp-dev php7-phar@php php7-pear@php php7-curl@php \
    php7-fpm@php php7-json@php php7-zlib@php php7-xml@php php7-dom@php php7-ctype@php php7-opcache@php php7-zip@php php7-iconv@php \
    php7-pdo@php php7-pdo_mysql@php php7-pdo_sqlite@php php7-pdo_pgsql@php php7-mbstring@php php7-session@php php7-mysqli@php\
    php7-openssl@php php7-sockets@php php7-posix@php php7-ldap@php php7-soap@php && \
    rm -f /etc/php7/php-fpm.d/www.conf && \
    touch /etc/php7/php-fpm.d/env.conf && \
	ln -s /etc/php7 /etc/php && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
    ln -s /usr/lib/php7 /usr/lib/php && \
    rm -fr /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --filename=/usr/local/bin/composer

RUN rm -rf /var/www/* && mkdir /var/www/app

COPY files/php/conf.d/local.ini /etc/php7/conf.d/
COPY files/php/php-fpm.conf /etc/php7/
COPY files/php/phpinfo.php /var/www/app/index.php
COPY files/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/services.d /etc/services.d
COPY files/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
