DOCKER_IMAGE := mgcrea/node
IMAGE_VERSION := 6.10.3
BASE_IMAGE := ubuntu:16.04

all: build

run:
	@docker run --privileged --rm --net=host -it ${DOCKER_IMAGE}:${IMAGE_VERSION}

bash:
	@docker run --privileged --rm --net=host -it ${DOCKER_IMAGE}:${IMAGE_VERSION} /bin/bash

build:
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:latest .

base:
	@docker pull ${BASE_IMAGE}

rebuild: base
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:latest .

release: rebuild
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:${IMAGE_VERSION} .
	@scripts/tag.sh ${DOCKER_IMAGE} ${IMAGE_VERSION}

push:
	@scripts/push.sh ${DOCKER_IMAGE} ${IMAGE_VERSION}

test:
	@docker run --rm --entrypoint /bin/bash -it ${DOCKER_IMAGE}:latest
