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

chown -R www-data:www-data /var/www/other /var/www/.ssh
chown www-data:www-data /var/www/source /var/www/

/usr/local/bin/supervisord