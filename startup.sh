#!/bin/bash
echo -e "\n Local OSM server instance startup."

FILE=./data/geoserver/data_dir/data/osm-lowres.gpkg
if [ ! -f "$FILE" ]; then
    echo -e "\n ----- OSM Low resolution file ($FILE) does not exist."
    echo -e "\n ----- Download and configure file in data folder."
    curl "https://link.us1.storjshare.io/s/jxjnkchpopbfqozdoz5r3x56mebq/osm/osm-lowres-modified.zip?download=1" -o ./osm-lowres-modified.zip
    unzip -o ./osm-lowres-modified.zip
    mv ./osm-lowres-modified.gpkg ./data/geoserver/data_dir/data/osm-lowres.gpkg
fi

echo -e "\n ----- Docker-compose startup."
docker-compose -f ./docker-compose.yml up -d

echo -e "\n ----- Importing PBFs files allocated in pbfs folder."
cd ./imposm/
./import-pg.sh -i ../pbfs/ -c osm-geoserver-postgis_postgis -v 12.1 -p 5432 -r false
cd ../
# Once imported, pbfs files are moved to another folder
count=`ls -1 ./pbfs/*.pbf 2>/dev/null | wc -l`
if [ $count != 0 ]; then 
   mv ./pbfs/*.pbf ./pbfs/imported
fi 

