FROM ubuntu:16.04
MAINTAINER Olivier Louvignes <olivier@mgcrea.io>

ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-6.9.2}
ENV NODE_VERSION $IMAGE_VERSION
ENV NODE_USER www-data
ENV NODE_GROUP www-data
ENV UID 33
ENV GID 33

# apt update
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.9
RUN set -x \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

# install buildpack-deps packages
# https://github.com/docker-library/buildpack-deps/blob/master/jessie/Dockerfile
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    bzip2 \
    file \
    g++ \
    gcc \
    # imagemagick \
    libbz2-dev \
    libc6-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libevent-dev \
    libffi-dev \
    libgdbm-dev \
    libgeoip-dev \
    libglib2.0-dev \
    libjpeg-dev \
    libkrb5-dev \
    liblzma-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmysqlclient-dev \
    libncurses-dev \
    libpng-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libwebp-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    make \
    patch \
    xz-utils \
    zlib1g-dev

# install node
ENV NPM_CONFIG_LOGLEVEL info
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --keyserver keyserver.ubuntu.com --recv-keys 0x0B5CA946 \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# install custom packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ffmpeg \
    git \
    graphicsmagick-imagemagick-compat \
    iputils-ping \
    jq \
    libav-tools \
    libcairo2-dev \
    libgif-dev \
    libjpeg8-dev \
    libkrb5-dev \
    libpango1.0-dev \
    mediainfo \
    nano \
    net-tools \
    openssl \
    rsync \
    screen \
    software-properties-common \
    tmux \
    vim

# install custom node_modules
RUN npm i -g nodemon @mgcrea/yarn

# apt cleanup 
RUN apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# setup home
RUN mkdir /var/www \
  && chown $NODE_USER:$NODE_GROUP /var/www

# volume
WORKDIR /srv/www
VOLUME ["/srv/www"]

ADD ./files/init.sh /sbin/init.sh
RUN chmod 770 /sbin/init.sh
CMD ["/sbin/init.sh"]
