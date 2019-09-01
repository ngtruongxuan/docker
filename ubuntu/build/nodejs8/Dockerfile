FROM gitlab.hub.seldatdirect.com/docker-image/ubuntu16:supervisor

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -qq  -y  language-pack-en-base

# Install GIT
RUN apt-get install -qq python-software-properties -y

RUN add-apt-repository ppa:git-core/ppa && \
    apt-get update -qq && \
    apt-get install -qq git -y

# Install nginx
COPY config/etc/apt/sources.list.d/nginx-ubuntu-stable-xenial.list /etc/apt/sources.list.d/nginx-ubuntu-stable-xenial.list
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
COPY config/nginx-supervisor.conf /etc/supervisor/conf.d/nginx-supervisor.conf
COPY config/nginx.conf /etc/nginx/nginx.conf