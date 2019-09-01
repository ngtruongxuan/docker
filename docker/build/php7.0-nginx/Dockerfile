FROM gitlab.hub.seldatdirect.com/docker-image/ubuntu16:nodejs8
ENV PHP_VERSION 7.0

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update -qq && apt-get install -qq -y zip nano curl
# Copy Config
COPY config/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf

# Install composer
RUN wget https://getcomposer.org/download/$(curl -s https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | cut -d '"' -f 4)/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Install php7 & module
RUN apt-get install -qq -y php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-fpm \
                            php$PHP_VERSION-gd php$PHP_VERSION-json php$PHP_VERSION-mysql \
                            php$PHP_VERSION-readline php$PHP_VERSION-mbstring \
                            php$PHP_VERSION-dom php$PHP_VERSION-curl \
                            php$PHP_VERSION-zip php$PHP_VERSION-common \
                            php$PHP_VERSION-mcrypt php$PHP_VERSION-bcmath \
                            php$PHP_VERSION-opcache php$PHP_VERSION-bz2 php$PHP_VERSION-gmp \
                            php$PHP_VERSION-redis php$PHP_VERSION-soap php$PHP_VERSION-amqp

RUN service php$PHP_VERSION-fpm start

COPY config/etc/php/$PHP_VERSION/fpm/pool.d/www.conf /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
COPY config/etc/php/$PHP_VERSION/fpm/php.ini /etc/php/$PHP_VERSION/fpm/php.ini
COPY config/etc/php/$PHP_VERSION/fpm/php-fpm.conf /etc/php/$PHP_VERSION/fpm/php-fpm.conf