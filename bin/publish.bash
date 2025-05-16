#!/usr/bin/env bash
DIR="$(realpath "${BASH_SOURCE%/*}")"

IMAGE="petrknap/letsencrypt-nginx-reverse-proxy"
PROJECT_VERSION_RELEASE=$(git describe --tags --abbrev=0 | cut -d "v" -f 2)
PROJECT_VERSION_MINOR=$(echo "${PROJECT_VERSION_RELEASE}" | cut -d "." -f 1,2)
PROJECT_VERSION_MAJOR=$(echo "${PROJECT_VERSION_RELEASE}" | cut -d "." -f 1)

docker build "${DIR}/.." \
  -t "${IMAGE}:${PROJECT_VERSION_RELEASE}" \
  -t "${IMAGE}:${PROJECT_VERSION_MINOR}" \
  -t "${IMAGE}:${PROJECT_VERSION_MAJOR}" \
  -t "${IMAGE}:latest" \
;

echo docker image push "${IMAGE}:${PROJECT_VERSION_RELEASE}"
echo docker image push "${IMAGE}:${PROJECT_VERSION_MINOR}"
echo docker image push "${IMAGE}:${PROJECT_VERSION_MAJOR}"
echo docker image push "${IMAGE}:latest"
