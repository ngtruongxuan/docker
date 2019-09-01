FROM github.com/ngtruongxuan/docker.git#:ubuntu/build/php7.0-nginx
RUN apt-get install -qq -y php$PHP_VERSION-dev pkg-config
RUN pecl install mongodb
COPY config/etc/php/$PHP_VERSION/mods-available/mongodb.ini /etc/php/$PHP_VERSION/mods-available/

RUN phpenmod mongodb