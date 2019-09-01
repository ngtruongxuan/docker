FROM ubuntu:16.04
VOLUME ["/var/www/", "/var/log/supervisor/", "/var/log/nginx/", "/var/log/apache2/" ,"/tmp", "/var/log/dev-log"]

ENV TERM=xterm
RUN apt-get update -qq && apt-get upgrade -y
RUN apt-get install -qq -y --no-install-recommends apt-utils
RUN apt-get install -qq -y software-properties-common wget net-tools nano curl iputils-ping python sudo && apt-get autoremove

RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && python /tmp/get-pip.py
RUN pip install supervisor

COPY config/dev-groups /etc/sudoers.d/dev-group

RUN echo 'Defaults:%sudo      !authenticate' >> /etc/sudoers.d/sudo-group && chmod 440 /etc/sudoers.d/sudo-group

COPY config/supervisor-service.conf /etc/supervisor/conf.d/service.conf
COPY config/supervisord.conf /etc/supervisor/supervisord.conf

RUN addgroup devs && \
    addgroup gits && \
    mkdir /root/setting

COPY config/bash_alias /etc/skel/.bash_aliases
COPY config/bash_alias /root/.bash_aliases
COPY config/bashrc /etc/skel/.bashrc
COPY config/bashrc /root/.bashrc
COPY config/known_hosts /root/setting/known_hosts

RUN chmod 0440 /etc/sudoers.d/dev-group
RUN adduser dev --gecos "" --disabled-password && adduser dev devs;

COPY config/init.sh /root/init.sh
EXPOSE 80
CMD ["bash","/root/init.sh"]