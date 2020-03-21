#!/bin/bash

VERSION=$(cat ./VERSION)

VERSION_IMAGE_NAME=emilioforrer/ci-tools:${VERSION}

LATEST_VERSION_IMAGE_NAME=emilioforrer/ci-tools:latest

DOCKER_VERSION_IMAGE_NAME=docker:19

docker build --build-arg DOCKER_VERSION_IMAGE_NAME=${DOCKER_VERSION_IMAGE_NAME}-dind -t ${LATEST_VERSION_IMAGE_NAME}-dind -t ${VERSION_IMAGE_NAME}-dind .

docker build --build-arg DOCKER_VERSION_IMAGE_NAME=${DOCKER_VERSION_IMAGE_NAME} -t ${LATEST_VERSION_IMAGE_NAME}  -t ${VERSION_IMAGE_NAME}  .

# docker push ${VERSION_IMAGE_NAME}
# docker push ${VERSION_IMAGE_NAME}-dind

# docker push ${LATEST_VERSION_IMAGE_NAME}
# docker push ${LATEST_VERSION_IMAGE_NAME}-dind
