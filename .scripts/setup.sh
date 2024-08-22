#!/bin/bash

SERVICE_NAME="docker"

# Docker setup

if ! dpkg -l | grep docker &>/dev/null; then
    echo "Docker is not installed, installing it now..."
    sudo apt install docker.io
    echo "Setting $USER in the docker group..."
    sudo usermod -aG docker $USER
    echo "Docker was installed, please logout and login again in the system, this is required only once."
    exit 0
fi

# Check if docker service is running

if systemctl is-active --quiet $SERVICE_NAME; then
    echo "$SERVICE_NAME is running."
else
    echo "$SERVICE_NAME service is not running, can't proceed!"
    exit 1
fi

# Build image, run container, wait, open browser

docker pull squidfunk/mkdocs-material
echo "Creating and running mkdocs docker container"
docker run --rm -it -d -p 8000:8001 -v $(pwd):/docs --name mkdocs squidfunk/mkdocs-material
sleep 3
google-chrome "http://localhost:8001/"