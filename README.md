Esta imagem esta disponivel em evecimar/laravel-5.6

Esta imagem é baseada no repositório https://github.com/codecasts/php-alpine


Para criar um nova imagem. Baixe este arquivo e build a nova imagem com base no DockerFile

Ex: docker build -t evecimar/laravel-5.6 .
 

Relação de variaveis de ambiente:

git_url => URL para fazer o git clone. Deve ser http/s com login e senha na url 
git_branch => Nome do branch que deseja clonar
custom_command_url => link para o arquivo com comando para serem executados