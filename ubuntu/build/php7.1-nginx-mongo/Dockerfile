FROM github.com/ngtruongxuan/docker.git#:ubuntu/build/php7.1-nginx
RUN apt-get install -qq -y php$PHP_VERSION-dev pkg-config && \
    pecl install mongodb && \
    echo '; configuration for php mongodb module\n\
    ; priority=20\n\
    extension=mongodb.so' >> /etc/php/$PHP_VERSION/mods-available/mongodb.ini && \
    apt-get remove -qq -y php$PHP_VERSION-dev pkg-config && \
    apt-get autoremove -y

RUN phpenmod mongodb