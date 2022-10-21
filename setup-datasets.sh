#!/bin/bash
echo -e "\n Setup High and Low resolution datasets."

FILE=./data/geoserver/data_dir/data/osm-lowres.gpkg
if [ ! -f "$FILE" ]; then
    echo -e "\n ----- OSM Low resolution file ($FILE) does not exist."
    echo -e "\n ----- Download and configure file in data folder."
    curl "https://link.us1.storjshare.io/s/jumximeaymxkett2lt66cid2l4pq/osm/osm-lowres-modified.zip?download=1" -o ./osm-lowres-modified.zip
    unzip -o ./osm-lowres-modified.zip
    mv ./osm-lowres-modified.gpkg ./data/geoserver/data_dir/data/osm-lowres.gpkg
fi

# Download my Selection PBF (ie. Suriname)
FILE=./pbfs/suriname-latest.osm.pbf
if [ ! -f "$FILE" ]; then
    echo -e "\n ----- OSM High resolution file ($FILE) does not exist."
    echo -e "\n ----- Download and configure file in data folder."
    curl "https://download.geofabrik.de/south-america/suriname-latest.osm.pbf" -o ./pbfs/suriname-latest.osm.pbf
fi
