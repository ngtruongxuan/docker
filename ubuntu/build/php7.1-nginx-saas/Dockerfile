FROM github.com/ngtruongxuan/docker.git#:ubuntu/build/php7.1-nginx-mongo
COPY lib/ /root/lib/
COPY lib/zephir_parser.so /usr/lib/php/20160303/
COPY init.sh /root/
RUN echo '; configuration for php zephir module\n\
    ; priority=20\n\
    extension=zephir_parser.so' >> /etc/php/$PHP_VERSION/mods-available/zephir_parser.ini                                                                                                               && \
    phpenmod zephir_parser                                                                                                                                                                              && \
    ## install JAVA                                                                                                                                                                                     && \
    wget -O /tmp/jdk-8u201-linux-x64.tar.gz https://s3.amazonaws.com/seldat-cdn/files/jdk/jdk-8u201-linux-x64.tar.gz                                                                                    && \
    mkdir /opt/jdk/ && tar -xzf /tmp/jdk-8u201-linux-x64.tar.gz --directory /opt/jdk/                                                                                                                   && \
    update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_201/bin/java 100 && update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_201/bin/javac 100                       && \
    rm /tmp/jdk-8u201-linux-x64.tar.gz

