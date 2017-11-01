PROJECTFOLDER='projeto'
PROJECTNAME="devs"
SERVERADMIN="wesleysilva.ti@gmail.com"
SERVERNAME="devs.dev"

echo "--- arquivo host ---"
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerAdmin ${SERVERADMIN}
    ServerName  ${SERVERNAME}
    ServerAlias ${SERVERNAME}
    DocumentRoot "/var/www/html/${PROJECTFOLDER}/public"
    <Directory "/var/www/html/${PROJECTFOLDER}/public">
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

echo "--- ativar host"
sudo a2ensite ${PROJECTNOME}

echo "-- gerar projeto laravel"
composer create-project --prefer-dist laravel/laravel /var/www/html/${PROJECTFOLDER}/${PROJECTNOME}
    
echo "[OK] --- Ambiente de desenvolvimento concluido ---"
