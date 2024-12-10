#!/bin/bash

export $(grep -v '^#' .env | xargs)

DATE_TAG=$(date +%d-%m-%Y)
# DATE_TAG="v1"
IMAGE_NAME="cinema-backend"
DOCKERHUB_USERNAME=$(echo $DOCKERHUB_USERNAME | tr -d '\r')

if [ -z "$DOCKERHUB_USERNAME" ]; then
  echo "Zmienna DOCKERHUB_USERNAME nie jest ustawiona. Proszę dodaj ją do pliku .env."
  exit 1
fi

docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:latest .

docker login
docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest