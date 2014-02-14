#!/bin/bash

# remove all containers
docker rm $(docker ps -a -q)

# remove all images
docker rmi $(docker images -q)
