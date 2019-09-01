FROM github.com/ngtruongxuan/docker.git#:ubuntu/build/supervisor
ENV PHP_VERSION 7.1

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update -qq && apt-get install -qq -y zip nano curl apache2 libapache2-mod-php$PHP_VERSION
RUN a2enmod proxy_fcgi setenvif

# Install GIT
RUN apt-get install -qq python-software-properties -y

RUN add-apt-repository ppa:git-core/ppa && \
    apt-get update -qq && \
    apt-get install -qq git -y


# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -qq nodejs
RUN npm install -g bower

RUN mkdir /usr/npm && \
    mkdir /usr/etc && \
    echo 'sass_binary_path=/usr/npm/linux-x64-57_binding.node' >> /usr/etc/npmrc && \
    wget https://github.com/sass/node-sass/releases/download/v4.11.0/linux-x64-57_binding.node -O /usr/npm/linux-x64-57_binding.node

COPY config/apache2-supervisor.conf /etc/supervisor/conf.d/apache2-supervisor.conf

# Install Composer
RUN wget https://getcomposer.org/download/$(curl -s https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | cut -d '"' -f 4)/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN a2enmod rewrite

# Install php7 & module
RUN apt-get install -qq -y php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-fpm \
                            php$PHP_VERSION-gd php$PHP_VERSION-json php$PHP_VERSION-mysql \
                            php$PHP_VERSION-readline php$PHP_VERSION-mbstring \
                            php$PHP_VERSION-dom php$PHP_VERSION-curl \
                            php$PHP_VERSION-zip php$PHP_VERSION-common \
                            php$PHP_VERSION-mcrypt php$PHP_VERSION-bcmath \
                            php$PHP_VERSION-opcache php$PHP_VERSION-bz2 php$PHP_VERSION-gmp \
                            php$PHP_VERSION-redis php$PHP_VERSION-soap php$PHP_VERSION-amqp

RUN rm /etc/apache2/sites-enabled/000-default.conf

COPY config/etc/php/$PHP_VERSION/apache2/php.ini /etc/php/$PHP_VERSION/apache2/php.ini
RUN echo 'IncludeOptional /var/www/other/vhost/*.conf' >> /etc/apache2/sites-enabled/config.conf