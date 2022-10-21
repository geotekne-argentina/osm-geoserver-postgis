#!/bin/bash
echo -e "\n Local OSM server instance startup."
echo -e "\n ----- Docker-compose startup."
docker-compose -f ./docker-compose.yml up -d
