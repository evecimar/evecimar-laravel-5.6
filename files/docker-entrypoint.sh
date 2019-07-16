#!/bin/bash
set -e

git=$git_url
nginx=$nginx_conf_url
command=$custom_command_url
project_dir="/var/www/app"

cd /var/www/app/
if [ ! -z $git ]
then
    cd /var/www/app/

    if [ -z $git_branch ]
        then
        git_branch=master
    fi
    git clone -b $git_branch $git_url

    repo_url=$git_url
    repo=${repo_url##*/}
    project_dir=/var/www/app/${repo%%.git*}
    mv $project_dir/* /var/www/app/
    
    file="docker/nginx.conf"
    if [ -f "$file" ]
    then
        mv docker/nginx.conf /etc/nginx/nginx.conf
    fi

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
