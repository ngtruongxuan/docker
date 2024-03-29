if [ ! -f /usr/local/bin/docker-compose ]; then
    if [ ! -f /var/lib/boot2docker/docker-compose ]; then
        curl -L https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d '"' -f 4)/docker-compose-`uname -s`-`uname -m` > /var/lib/boot2docker/docker-compose
    fi
    cp /var/lib/boot2docker/docker-compose /usr/local/bin/docker-compose
fi
chmod +x /usr/local/bin/docker-compose