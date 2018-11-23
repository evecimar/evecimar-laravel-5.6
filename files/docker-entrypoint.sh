#!/bin/bash
set -e

if [ -n $git_url ]
then
    cd /var/www/app/
    git clone -b $git_branch $git_url
fi

if [ -n $custom_command_url ]
then

    wget $custom_command_url -o /start.sh
    chmod +x /start.sh
    /start.sh
fi

crond
nginx
php-fpm7