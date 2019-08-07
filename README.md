Esta imagem esta disponivel em evecimar/laravel-5.6

Esta imagem é baseada no repositório https://github.com/codecasts/php-alpine


Para criar um nova imagem. Baixe este arquivo e build a nova imagem com base no DockerFile

Ex: docker build -t evecimar/laravel-5.6 .
 

Relação de variaveis de ambiente:

git_url => URL para fazer o git clone. Deve ser http/s com login e senha na url
git_branch => Nome do branch que deseja clonar
nginx_conf_url => URL do arquivo nginx.conf caso tenha que mudar a pasta padrão que é /var/www/app/public 
custom_command_url => link para o arquivo com comando para serem executados



#Exemplos de arquivos:

##nginx.conf

user nginx;
worker_processes 1;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile           on;
    tcp_nopush         on;
    tcp_nodelay        on;
    keepalive_timeout  65;
    server_tokens      off;
    access_log         off;
    error_log          /dev/stderr;

    server {
        listen       80;
        server_name  localhost;
        index        index.php;
        root         /var/www/app/public;
        client_max_body_size 32M;

        location / {
            try_files $uri $uri/ /index.php$is_args$args;
        }

        location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/var/run/php-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_index index.php;
            include fastcgi_params;
        }

        location ~* ^.+\.(log|sqlite)$ {
            return 404;
        }

        location ~ /\.ht {
            return 404;
        }

        location ~* ^.+\.(ico|jpg|gif|png|css|js|svg|eot|ttf|woff|woff2|otf)$ {
            log_not_found off;
            expires 7d;
            etag on;
        }

        gzip on;
        gzip_comp_level 3;
        gzip_disable "msie6";
        gzip_vary on;
        gzip_types
            text/javascript
            application/javascript
            application/json
            text/xml
            application/xml
            application/rss+xml
            text/css
            text/plain;
    }
}

custom_command_url

#!/bin/bash
composer install
php artisam migrate


Obs.:
Todos os camandos são exeturados na pasta /var/www/app/, caso seu comando deva ser executado em uma pasta diferente, você deve mudar o diretório antes de executa-lo

Para sua segurança não execute códigos de terceiros.


#Projetos que estão dentro de pastas no git

No extato momento que escrevo este tutoral, eu estou trabalhando em um projeto laravel que fica dentro de uma pasta no git:

Meu git é: git@evecimar/projeto.git

a pasta public do meu projeto esta dentro da pasta admin, então quando fizer o clone, meu projeto ficara na seguinte estrutura no container:

/var/www/app/admin/

minha pasta public fica dentro de admin e o nginx.conf esta apontando para /var/www/app/public, desta forma é apresentando um erro ao tentar acesso o projeto.

Eu posso resolver este problema de duas maneira:

1 -
 Cria um arquivo nginx.conf com a variavel root contendo /var/www/app/admin/public, publico este arquivo em um local e passo a url do arquivo com env

2 - Crio um arquivo de comandos que move a pasta para a pasta root padrão addim:

#!/bin/bash

mv /var/www/app/admin/* /var/www/app/

Salvo o arquivo na web e passo o url como env custom_command_url