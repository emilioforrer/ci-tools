#!/bin/bash

VERSION=$(cat ./VERSION)

VERSION_IMAGE_NAME=emilioforrer/ci-tools:${VERSION}

LATEST_VERSION_IMAGE_NAME=emilioforrer/ci-tools:latest

docker build -t ${LATEST_VERSION_IMAGE_NAME}  -t ${VERSION_IMAGE_NAME}  .

# docker push ${VERSION_IMAGE_NAME}

# docker push ${LATEST_VERSION_IMAGE_NAME}
