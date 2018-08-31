#/usr/bin/env bash

echo "--- Instalando pacotes para desenvolvimento [PHP 7, LARAVEL]"

# Criar variaves para senha mysql, nome do projeto, projeto laravel e git
echo "--- definir senha e nome do projeto ---"
PASSWORD='123'
PROJECTFOLDER='projeto'
PROJECTNAME="website"
GITNAME="seu nome"
GITEMAIL="seuemal@seuemail"

echo "--- criar pasta do projeto ---"
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

echo "<?php phpinfo(); ?>" > /var/www/html/${PROJECTFOLDER}/index.php

echo "--- update / upgrade ---"
sudo apt-get update
sudo apt-get -y upgrade

echo "--- instalar apache2, php ---"
sudo apt-get -y install apache2
sudo apt-get -y install php libapache2-mod-php

echo "--- instalar cURL and Mcrypt ---"
sudo apt-get -y install php-curl
sudo apt-get -y install php-mcrypt
sudo apt-get -y install php7.0-mbstring
sudo apt-get -y install php-xml
sudo apt-get -y install php7.0-zip

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
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

echo "-- gerar projeto laravel"
composer create-project --prefer-dist laravel/laravel /var/www/html/${PROJECTFOLDER}/${PROJECTNAME}
sudo chmod -R 777 /var/www/html/${PROJECTFOLDER}/

echo "--- reiniciar apache ---"
sudo service apache2 restart
    
echo "[OK] --- Ambiente de desenvolvimento concluido ---"