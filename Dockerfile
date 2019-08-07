#Desenvolvido por Evecimar Silva - evecimar.com @evecimar
FROM alpine:3.8

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update add ca-certificates
RUN echo "https://dl.bintray.com/php-alpine/v3.8/php-7.2" >> /etc/apk/repositories
RUN apk add --update php
RUN apk add --update php-mbstring

RUN apk update && \
    apk add nginx git bash ca-certificates s6 curl ssmtp libzip-dev libwebp-dev php-phar php-pear php-curl \
    php-fpm php-json php-zlib php-xml php-dom php-ctype php-opcache php-zip php-iconv \
    php-pdo php-pdo_mysql php-pdo_sqlite php-pdo_pgsql php-mbstring php-session php-mysqli\
    php-openssl php-sockets php-posix php-ldap php-soap && \
    rm -f /etc/php7/php-fpm.d/www.conf && \
    touch /etc/php7/php-fpm.d/env.conf && \
	ln -s /etc/php7 /etc/php && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
    ln -s /usr/lib/php7 /usr/lib/php && \
    rm -fr /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php7 -- --filename=/usr/local/bin/composer

RUN rm -rf /var/www/* && mkdir /var/www/app

COPY files/php/conf.d/local.ini /etc/php7/conf.d/
COPY files/php/php-fpm.conf /etc/php7/
COPY files/php/phpinfo.php /var/www/app/index.php
COPY files/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/services.d /etc/services.d
COPY files/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
