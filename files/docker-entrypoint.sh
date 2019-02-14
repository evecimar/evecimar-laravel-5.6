#!/bin/bash
set -e

git=$git_url
nginx=$nginx_conf_url
command=$custom_command_url

cd /var/www/app/
if [ ! -z $git ]
then
    cd /var/www/app/

    if [ -z $git_branch ]
        then
        git_branch=master
    fi
    git clone -b $git_branch $git_url
fi

if [ ! -z  $nginx ]
then

    wget $nginx_conf_url -o /nginx.conf
    mv /nginx.conf /etc/nginx/nginx.conf
fi

if [ ! -z  $command ]
then

    wget $custom_command_url -o /start.sh
    chmod +x /start.sh
    /start.sh
fi

#/bin/s6-svscan
#/etc/services.d

crond
nginx
php-fpm7