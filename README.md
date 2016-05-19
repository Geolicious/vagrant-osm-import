# Vagrant-OSM-Import

A preconfigured Vagrant box running Ubuntu 14.04, PostgreSQL/Postgis and
imposm3, tailored for importing global OpenStreetMap data with a custom
mapping.

This is especially helpful if you want to work with larger amounts of
OpenStreetMap data without relying on the Overpass API, for creating
custom map tiles with Tilemill, or simply need some custom data mapping.

## Quickstart:

- install [Vagrant](vagrantup.com)
- if you want to try it out locally, install Virtualbox or LXC when on Linux
- if you want to run an import on a Digital Ocean Server:
  - install the Vagrant Digital Ocean Plugin: `vagrant plugin install vagrant-digitalocean`
  - copy file `vagrant_config.yml.example` to `vagrant_config.yml` and customize it to your needs
- configure:
  - create imposm mapping file `mapping.json` from `mapping.json.example` and customize it to contain your desired fields and tags
  - create PostgreSQL config file `postgresql.conf` from `postgresql.conf` and customize it (shared_buffers should be half of total system memory)
- run `vagrant up --provider=[virtualbox|lxc|digital_ocean]` on your local machine inside the repository and choose your provider
- wait for vagrant to complete downloading the Ubuntu base box and installing the software
- log into the VM by running `vagrant ssh`

## Download OSM Data and Import to PostgreSQL:

OSM imports are long-running processes that might take several hours to
complete. In case you don't want to keep the terminal/ssh session open
for hours, or cancelling the import instead, run the import inside a
terminal multiplexer like tmux or byobu.

Inside the VM you can run the `load-osm-data.sh` script to download OSM
data and import it to PostgreSQL.

When running the script, attach the download address of an OSM Planet file:

```bash
./load-osm-data.sh http://download.geofabrik.de/europe/germany/brandenburg-latest.osm.pbf
```

Example Download Sources:

- https://mapzen.com/data/metro-extracts
- http://download.geofabrik.de/

Depending on the size of the planet file, the download/import will take
some time. If the import fails or the resulting tables dont contain data,
check you postgresql.conf ressource settings (shared_buffers,
maintenance_work_mem, work_mem) and your mapping file. Refer to the
(imposm docs)[http://imposm.org/docs/imposm3/latest/mapping.html] for
how to write your own mapping. You can write them in JSON and YAML format.

## Use a Digital Ocean VPS instead of Virtualbox as provider

Install vagrant-digitalocean provider

`vagrant plugin install vagrant-digitalocean`

Start a box with provider digital_ocean

`vagrant up --provider=digital_ocean`


__Warning__

Depending on the size of the Digitalocean droplet you are running, you
get charged as long as your box is existing. Because the ressources are
reserved, you get charged for a stopped droplet too. If you dont want to
pay while not working on it, you can destroy the droplet with vagrant:
`vagrant destroy remote`.
The downside is that you have to run your data import every time you
recreate the droplet.

## Connect to the database

In order to access the data, you can use any PostgreSQL client.
On the machine where you started the Vagrant box, you can use localhost
with port 5433 to access it, with username "osm", database "osm",
password "osm". The port is being forwarded to you vagrant box.

These clients should work without problems:
 - QGIS
 - PGAdmin
 - psql commandline (`psql -U osm -d osm -h localhost -p 5433`)

## Contribute

If you are interested in making this tool better, fork it on GitHub and
make a Pull Request.
