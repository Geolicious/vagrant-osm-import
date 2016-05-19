#! /bin/sh

# load-osm-data.sh
#
# Download OSM data and import to local postgresql database
#
# Usage: ./load-osm-data.sh <URL to [regional] planetfile.osm.pbf>
#

mkdir -p /home/vagrant/osm
cd /home/vagrant/osm

echo '### Downloading OSM Planetfile...'
wget $1

echo '### Importing OSM data...'
cd /home/vagrant/
imposm/imposm3 import \
  -connection postgis://osm:osm@localhost/osm \
  -mapping /vagrant/mapping.json \
  -read osm/*.osm.pbf \
  -write \
  -optimize \
  -overwritecache \
  -deployproduction
