FROM ubuntu:16.04
VOLUME ["/var/www/", "/var/log/supervisor/", "/var/log/nginx/", "/var/log/apache2/" ,"/tmp", "/var/log/dev-log"]

ENV TERM=xterm
RUN apt-get update -qq && apt-get upgrade -y
RUN apt-get install -qq -y --no-install-recommends apt-utils
RUN apt-get install -qq -y software-properties-common wget net-tools nano curl iputils-ping python sudo && apt-get autoremove

RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && python /tmp/get-pip.py
RUN pip install supervisor

COPY resource/supervisor/config/dev-groups /etc/sudoers.d/dev-group

RUN echo 'Defaults:%sudo      !authenticate' >> /etc/sudoers.d/sudo-group && chmod 440 /etc/sudoers.d/sudo-group

COPY resource/supervisor/config/supervisor-service.conf /etc/supervisor/conf.d/service.conf
COPY resource/supervisor/config/supervisord.conf /etc/supervisor/supervisord.conf

RUN addgroup devs && \
    addgroup gits && \
    mkdir /root/setting

COPY resource/supervisor/config/bash_alias /etc/skel/.bash_aliases
COPY resource/supervisor/config/bash_alias /root/.bash_aliases
COPY resource/supervisor/config/bashrc /etc/skel/.bashrc
COPY resource/supervisor/config/bashrc /root/.bashrc
COPY resource/supervisor/config/known_hosts /root/setting/known_hosts

RUN chmod 0440 /etc/sudoers.d/dev-group
RUN adduser dev --gecos "" --disabled-password && adduser dev devs;

COPY resource/supervisor/config/init.sh /root/init.sh
EXPOSE 80
CMD ["bash","/root/init.sh"]

#### Install Nodejs
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -qq  -y  language-pack-en-base

# Install GIT
RUN apt-get install -qq python-software-properties -y

RUN add-apt-repository ppa:git-core/ppa && \
    apt-get update -qq && \
    apt-get install -qq git -y

# Install nginx
COPY resource/nodejs8/config/etc/apt/sources.list.d/nginx-ubuntu-stable-xenial.list /etc/apt/sources.list.d/nginx-ubuntu-stable-xenial.list
RUN apt-key adv --fetch-keys http://nginx.org/keys/nginx_signing.key && apt-get update && apt-get install -y nginx

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -qq nodejs
RUN npm install -g bower

RUN mkdir /usr/npm && \
    mkdir /usr/etc && \
    echo 'sass_binary_path=/usr/npm/linux-x64-57_binding.node' >> /usr/etc/npmrc && \
    wget https://github.com/sass/node-sass/releases/download/v4.11.0/linux-x64-57_binding.node -O /usr/npm/linux-x64-57_binding.node
ENV NPM_CONFIG_USERCONFIG /usr/etc/npmrc
# Copy Config
COPY resource/nodejs8/config/nginx-supervisor.conf /etc/supervisor/conf.d/nginx-supervisor.conf
COPY resource/nodejs8/config/nginx.conf /etc/nginx/nginx.conf

### End install Nodejs

### Install PHP7.2
ENV PHP_VERSION 7.2

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update -qq && apt-get install -qq -y zip nano curl

# Copy Config
COPY resource/php7.2/config/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf

# Install composer
RUN wget https://getcomposer.org/download/$(curl -s https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | cut -d '"' -f 4)/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Install php7 & module
RUN apt-get install -qq -y php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-fpm \
                            php$PHP_VERSION-gd php$PHP_VERSION-json php$PHP_VERSION-mysql \
                            php$PHP_VERSION-readline php$PHP_VERSION-mbstring \
                            php$PHP_VERSION-dom php$PHP_VERSION-curl \
                            php$PHP_VERSION-zip php$PHP_VERSION-common \
                            php$PHP_VERSION-bcmath \
                            php$PHP_VERSION-opcache php$PHP_VERSION-bz2 php$PHP_VERSION-gmp \
                            php$PHP_VERSION-redis php$PHP_VERSION-soap php$PHP_VERSION-amqp

RUN service php$PHP_VERSION-fpm start

COPY resource/php7.2/config/etc/php/$PHP_VERSION/fpm/pool.d/www.conf /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
COPY resource/php7.2/config/etc/php/$PHP_VERSION/fpm/php.ini /etc/php/$PHP_VERSION/fpm/php.ini
COPY resource/php7.2/config/etc/php/$PHP_VERSION/fpm/php-fpm.conf /etc/php/$PHP_VERSION/fpm/php-fpm.conf

### End install PHP7.2

### Install MongoDB
RUN apt-get install -qq -y php$PHP_VERSION-dev pkg-config && \
    pecl install mongodb && \
    echo '; configuration for php mongodb module\n\
    ; priority=20\n\
    extension=mongodb.so' >> /etc/php/$PHP_VERSION/mods-available/mongodb.ini && \
    apt-get remove -qq -y php$PHP_VERSION-dev pkg-config && \
    apt-get autoremove -y

RUN phpenmod mongodb

### End install MongoDB
