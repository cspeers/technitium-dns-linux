#!/usr/bin/env bash
source build.config
echo "building $DOCKER_BASE_IMAGE"
docker build --build-arg BASE_IMAGE=$DOCKER_BASE_IMAGE -t $IMAGE_NAME:$DOCKER_IMAGE_TAG -t $IMAGE_NAME:$DOCKER_APPLICATION_VERSION .