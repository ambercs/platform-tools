#!/bin/bash
printf "DOCKER LAUNCH\n\n"
printf "Available images\n\n"
docker images

printf "\n\nOPTIONS
1. Run default image selection
OR
2. Select repo/image/tag\n"
read -r selection

REPO="pcfplatformrecovery"
IMAGE="bbr-pcf-pipeline-tasks"
TAG="final"
if [ "$selection" == "2" ] || [ "$selection" == "select" ] || [ "$selection" == "Select" ]; then
    printf "\nEnter repo: "
    read -r REPO
    export REPO=$REPO
    printf "\nEnter image: "
    read -r IMAGE
    export IMAGE=$IMAGE
    printf "\nEnter tag: "
    read -r TAG
    export TAG=$TAG
    printf "\n\n"
fi

printf "Running example for pulling and running a docker image\n\n"
printf "Pulling image\n"
docker pull "$REPO"/"$IMAGE":"$TAG"
printf "\n\nRunning command on image\n"
docker run -it --rm -v "$PWD":/workspace -w /workspace "$REPO"/"$IMAGE":"$TAG" ls -l
printf "\n\nAccessing image\n"
docker run -it --rm -v "$PWD":/workspace -w /workspace "$REPO"/"$IMAGE":"$TAG"
