#!/usr/bin/env bash
#set to the name of the Docker image you want to use
DOCKER_IMAGE_NAME=openstacks

# Stop on first error
set -e

if [ -e Dockerfile ]; then
  # Build a custom Docker image that has custom Jekyll plug-ins installed
  docker build --tag $DOCKER_IMAGE_NAME --file Dockerfile .

  # Remove dangling images from previous runs
  docker rmi -f $(docker images --filter "dangling=true" -q) > /dev/null 2>&1 || true
else
  # Use an existing Jekyll Docker image
  DOCKER_IMAGE_NAME=grahamc/jekyll
fi

echo "***********************************************************"
echo "  Your site will be available at http://localhost:4000"
echo "***********************************************************"

# Start Jekyll and watch for changes
docker run --rm \
  --volume=$(pwd):/src \
  --publish 4000:4000 \
  $DOCKER_IMAGE_NAME \
  serve --watch --drafts -H 0.0.0.0
