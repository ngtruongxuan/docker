#!/bin/bash
docker pull ubuntu:16.04 &&
docker-compose -f docker-build.yml build supervisor nodejs8 php7.1-nginx php7.1-nginx-mongo php7.2-nginx php7.2-nginx-mongo php7.3-nginx php7.3-nginx-mongo &&
docker push gitlab.hub.seldatdirect.com/docker-image/ubuntu16:supervisor &&
docker push gitlab.hub.seldatdirect.com/docker-image/ubuntu16:nodejs8 &&
docker push gitlab.hub.seldatdirect.com/docker-image/ubuntu16:php7.1-nginx &&
docker push gitlab.hub.seldatdirect.com/docker-image/ubuntu16:php7.1-nginx-mongo &&
docker push gitlab.hub.seldatdirect.com/docker-image/ubuntu16:php7.2-nginx &&
docker push gitlab.hub.seldatdirect.com/docker-image/ubuntu16:php7.2-nginx-mongo &&
docker push gitlab.hub.seldatdirect.com/docker-image/ubuntu16:php7.3-nginx &&
docker push gitlab.hub.seldatdirect.com/docker-image/ubuntu16:php7.3-nginx-mongo