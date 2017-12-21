#!/bin/bash

# Clean all containers
ALL_CONTAINERS_RUNNING=`docker ps -q`
ALL_CONTAINERS=`docker ps -a -q`

if [ "$ALL_CONTAINERS_RUNNING" != "" ]; then
    echo "Killing Running Containers..."
    KILL=`docker kill $ALL_CONTAINERS_RUNNING`
fi

if [ "$ALL_CONTAINERS" != "" ]; then
    echo "Removing Containers..."
    REMOVE=`docker rm $ALL_CONTAINERS`
else
    echo "No containers to remove"
fi

#Clean all Images except the base one
ALL_IMAGES_BUT_UBUNTU=`docker images | grep -v "ubuntu" | awk '{print $3}' | grep -v "IMAGE"`

if [ "$ALL_IMAGES_BUT_UBUNTU" != "" ]; then
    echo "Removing images..."
    REMOVE=`docker rmi $ALL_IMAGES_BUT_UBUNTU`
else
    echo "No images to remove"
fi
