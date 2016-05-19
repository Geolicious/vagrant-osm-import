#! /bin/sh

# set locale:
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# update package index:
apt-get update

# install packages:
apt-get install -y \
    htop \
    byobu \
    postgresql-9.3 \
    postgresql-9.3-postgis-2.1

# deploy custom postgresql configs and restart the service:
rm /etc/postgresql/9.3/main/pg_hba.conf
cp /vagrant/config/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
chown postgres:postgres /etc/postgresql/9.3/main/pg_hba.conf

rm /etc/postgresql/9.3/main/postgresql.conf
cp /vagrant/config/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
chown postgres:postgres /etc/postgresql/9.3/main/postgresql.conf

service postgresql restart

# setup database, db user and postgis
su - postgres -c "psql -c \"CREATE USER osm PASSWORD 'osm';\""
su - postgres -c "psql -c 'CREATE DATABASE osm OWNER osm;'"
su - postgres -c "psql -d osm -c 'CREATE EXTENSION postgis;'"

# install imposm3
wget -q http://imposm.org/static/rel/imposm3-0.2.0dev-20160311-77162d9-linux-x86-64.tar.gz
tar -xzf imposm3-0.2.0dev-20160311-77162d9-linux-x86-64.tar.gz
mv imposm3-0.2.0dev-20160311-77162d9-linux-x86-64/ imposm
