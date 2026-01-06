FROM debian:12-slim

RUN apt-get update && apt-get install -y wget python3-distutils meson gcc libpq-dev libssl-dev libxml2-dev \
pkg-config liblz4-dev libzstd-dev libbz2-dev libz-dev libyaml-dev libssh2-1-dev \
postgresql postgresql-client postgresql-contrib

WORKDIR /app

COPY . .

RUN meson setup build

RUN ninja -C build
