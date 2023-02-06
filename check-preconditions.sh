#!/bin/bash
echo -e "\nChecking preconditions: "
echo -e "\n1.- Git installation "
if [[ $(which git) && $(git --version) ]]; then
    echo "Git is ready !"
    git --version
else
    echo "Git is not ready ! Please install it."
fi
echo -e "\n2.- Docker installation "
if [[ $(which docker) && $(docker --version) ]]; then
    echo "Docker is ready !"
    docker --version
else
    echo "Docker is not ready ! Please install it."
fi
echo -e "\n3.- Docker compose (V2) installation "
if [[ $(which docker) && $(docker compose version) ]]; then
    echo "Docker compose (V2) is ready !"
    docker compose version
else
    echo "Docker compose (V2) is not ready ! Please install it."
fi
