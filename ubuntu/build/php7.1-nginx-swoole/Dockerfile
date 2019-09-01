FROM gitlab.hub.seldatdirect.com/docker-image/ubuntu16:php7.1-nginx
COPY swoole.so /usr/lib/php/20160303/
RUN echo '; configuration for php swoole module\n\
; priority=20\n\
extension=swoole.so' >> /etc/php/7.1/mods-available/swoole.ini
RUN phpenmod swoole