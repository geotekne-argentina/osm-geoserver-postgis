#!/bin/sh
# requires graphviz2drawio installed https://github.com/hbmartin/graphviz2drawio
DIR=$(pwd)
docker run --rm -it -v $DIR:/input --name dcv pmsipilot/docker-compose-viz render -m image --force docker-compose.yml --output-file=diagram.png
docker run --rm -it -v $DIR:/input --name dcv pmsipilot/docker-compose-viz render -m dot --force docker-compose.yml --output-file=diagram.dot
graphviz2drawio $DIR/diagram.dot  $DIR/diagram.mxgraph.xml


