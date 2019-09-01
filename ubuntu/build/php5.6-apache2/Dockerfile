FROM github.com/ngtruongxuan/docker.git#:ubuntu/build/supervisor
ENV PHP_VERSION 5.6

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -qq -y  language-pack-en-base
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update -qq  && apt-get install -qq -y zip nano curl apache2 libapache2-mod-php$PHP_VERSION
RUN a2enmod proxy_fcgi setenvif

# Install GIT
RUN apt-get install -qq python-software-properties -y
RUN add-apt-repository ppa:git-core/ppa && apt-get update -qq  && apt-get install -qq git -y
RUN apt-get autoremove

COPY config/supervisor.conf /etc/supervisor/conf.d/apache.conf

RUN wget https://getcomposer.org/download/$(curl -s https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | cut -d '"' -f 4)/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN a2enmod rewrite

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -qq nodejs
RUN npm install -g bower

# Install php7 & module
RUN apt-get install -qq -y php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-fpm \
                            php$PHP_VERSION-gd php$PHP_VERSION-json php$PHP_VERSION-mysql \
                            php$PHP_VERSION-readline php$PHP_VERSION-mbstring \
                            php$PHP_VERSION-dom php$PHP_VERSION-curl \
                            php$PHP_VERSION-zip php$PHP_VERSION-common \
                            php$PHP_VERSION-mcrypt php$PHP_VERSION-bcmath \
                            php$PHP_VERSION-opcache php$PHP_VERSION-bz2 php$PHP_VERSION-gmp \
                            php$PHP_VERSION-redis php$PHP_VERSION-soap

RUN rm /etc/apache2/sites-enabled/000-default.conf

COPY config/etc/php/$PHP_VERSION/apache2/php.ini /etc/php/$PHP_VERSION/apache2/php.ini
RUN echo 'IncludeOptional /var/www/other/vhost/*.conf' >> /etc/apache2/sites-enabled/config.conf
