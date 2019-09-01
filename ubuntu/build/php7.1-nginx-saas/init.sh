#!/bin/bash
declare -a listFolder=("/var/www/other/vhost"
                        "/var/www/other/supervisord"
                         "/var/www/other/logs/supervisor"
                         )
for i in "${listFolder[@]}"
do
    mkdir -p $i
done

if [ ! -d "/var/www/.ssh" ]; then
    mkdir -p /var/www/.ssh
    cp /root/setting/known_hosts /var/www/.ssh
    chmod 660 /var/www/.ssh/known_hosts
    chmod -x /var/www/.ssh/known_hosts
fi

if [ ! -d "/var/www/source" ]; then
    mkdir -p /var/www/source
fi

sudo -u www-data mkdir -p /var/www/source/other/extension
mkdir /usr/local/sm/
chown www-data:www-data /usr/local/sm/


# Install saas
case "${PROJ_ENV}" in
        develop)
            cp /root/lib/saas_develop.so  /var/www/source/other/extension/saas.so
            sudo -u www-data wget -q https://s3.amazonaws.com/seldat-dev-public/saas/ext/develop/saas.jar -O /usr/local/sm/saas.jar
            ;;

        delivery)
            cp /root/lib/saas_delivery.so  /var/www/source/other/extension/saas.so
            sudo -u www-data wget -q https://s3.amazonaws.com/seldat-dev-public/saas/ext/staging/saas.jar -O /usr/local/sm/saas.jar
            ;;

        production)
            cp /root/lib/saas_production.so  /var/www/source/other/extension/saas.so
            sudo -u www-data wget -q https://s3.amazonaws.com/seldat-dev-public/saas/ext/production/saas.jar -O /usr/local/sm/saas.jar
            ;;
esac


if [ -f "/var/www/source/other/extension/saas.so" ]; then
    echo '; configuration for php saas module
    ; priority=20
    extension=/var/www/source/other/extension/saas.so' >> /etc/php/${PHP_VERSION}/mods-available/saas.ini
    phpenmod saas
fi

echo '[program:saas]
directory=/usr/local/sm/
command=java -jar saas.jar
user=www-data
redirect_stderr=true
autostart=true
autorestart=true
stdout_logfile=/var/log/dev-log/saas.log
exitcodes=0
' > /var/www/other/supervisord/saas.conf

chown -R www-data:www-data /var/www/other /var/www/.ssh
chown www-data:www-data /var/www/source /var/www/




/usr/local/bin/supervisord