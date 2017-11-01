#/usr/bin/env bash

echo "--- Instalando pacotes para desenvolvimento [PHP 7, LARAVEL]"

# Criar variaves para senha mysql, nome do projeto, projeto laravel e git
echo "--- definir senha e nome do projeto ---"
PASSWORD='123'
PROJECTFOLDER='projeto'
PROJECTNAME="website"
GITNAME="seu nome"
GITEMAIL="seunome@seunome"

echo "--- criar pasta do projeto ---"
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

echo "<?php phpinfo(); ?>" > /var/www/html/${PROJECTFOLDER}/index.php

echo "--- update / upgrade ---"
sudo apt-get update
sudo apt-get -y upgrade

echo "--- instalar apache2 and php5 ---"
sudo apt-get -y install apache2
sudo apt-get -y install php libapache2-mod-php

echo "--- instalar cURL and Mcrypt ---"
sudo apt-get -y install python-software-properties
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get -y install php libapache2-mod-php php-mcrypt php-mysql  
sudo apt-get -y install php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-mysql
sudo apt-get -y install php7.0-sqlite3

echo "--- instalar mysql e fornercer senha para o instalador -- "
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get -y install php-mysql

echo "--- instalar mysql e fornecer senha para o instalador"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

echo "--- arquivo host ---"
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}/${PROJECTNAME}/public"
    <Directory "/var/www/html/${PROJECTFOLDER}/${PROJECTNAME}/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

echo "--- habilitar mod-rewrite do apache ---"
sudo a2enmod rewrite

echo "--- reiniciar apache ---"
sudo service apache2 restart

echo "--- reiniciar mysql ---"
sudo service mysql restart

echo "--- instalando git ---"
sudo apt-get -y install git 
git config --global user.name ${GITNAME} 
git config --global user.email ${GITEMAIL}

echo "-- instalar composer"
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo "-- gerar projeto laravel"
composer create-project --prefer-dist laravel/laravel /var/www/html/${PROJECTFOLDER}/${PROJECTNAME}
    
echo "[OK] --- Ambiente de desenvolvimento concluido ---"