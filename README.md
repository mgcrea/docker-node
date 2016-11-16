# docker-node [![Docker Pulls](https://img.shields.io/docker/pulls/mgcrea/node.svg)](https://registry.hub.docker.com/u/mgcrea/node/)

Run node from a docker container

Based on `ubuntu:16.04` image, as `www-data` user with [gosu](https://github.com/tianon/gosu), with some extra packages & modules.

## Install
```sh
docker pull mgcrea/node:6
```

## Extra

- packages added:

```
ffmpeg
git
graphicsmagick-imagemagick-compat
iputils-ping
jq
libcairo2
libgif
libjpeg8
libpango1.0
libav-tools
libkrb5-dev
mediainfo
nano
net-tools
openssl
rsync
screen
software-properties-common
tmux
vim
```

- node_modules added:

```
nodemon
yarn
```

## Usage

```sh
docker run -d --restart=always \
  -v /srv/www:/srv/www \
  -p 3000:3000 \
  --name container_name \
  mgcrea/node:6
```

```sh
docker-compose up -d
```

### User/Group override

You can easily override the user/group used by the image using environment variables. Like in the following compose example:

```yaml
# https://docs.docker.com/compose/yml/

node:
  container_name: node
  hostname: node
  image: mgcrea/node:6
  environment:
    - NODE_USER=www-data
    - NODE_GROUP=www-data
    - UID=33
    - GID=33
  ports:
    - "3000:3000"
  volumes:
    - ./www:/srv/www
  restart: always
```

**NOTE**: for security reasons, starting this docker container will change the permissions of all files in your www directory to a new, docker-only user. This ensures that the docker container can access the files.

## Debug

Create and inspect a new instance

```sh
docker run --rm -it mgcrea/node:latest script -q -c "TERM=xterm /bin/bash" /dev/null
```

Inspect a running instance

```sh
docker exec -it test_node script -q -c "TERM=xterm /bin/bash" /dev/null
```
