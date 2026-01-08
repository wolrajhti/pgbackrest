FROM debian:12-slim

RUN apt-get update && apt-get install -y wget python3-distutils meson gcc libpq-dev libssl-dev libxml2-dev \
pkg-config liblz4-dev libzstd-dev libbz2-dev libz-dev libyaml-dev libssh2-1-dev \
postgresql postgresql-client postgresql-contrib

WORKDIR /app

COPY . .

RUN meson setup build

RUN ninja -C build

# installation steps for pgbackrest
RUN mkdir -p -m 770 /var/log/pgbackrest \
  chown postgres:postgres /var/log/pgbackrest \
  mkdir -p /etc/pgbackrest \
  mkdir -p /etc/pgbackrest/conf.d \
  touch /etc/pgbackrest/pgbackrest.conf \
  chmod 640 /etc/pgbackrest/pgbackrest.conf \
  chown postgres:postgres /etc/pgbackrest/pgbackrest.conf \

  mv /app/build/src/pgbackrest /usr/bin/pgbackrest \

# setup demo database cluster

  pg_dropcluster 15 main --stop \
  pg_createcluster 15 demo \
  pg_ctlcluster 15 demo restart \

  # create the repository

  mkdir -p /var/lib/pgbackrest \
  chmod 750 /var/lib/pgbackrest \
  chown postgres:postgres /var/lib/pgbackrest \
