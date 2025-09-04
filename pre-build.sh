#!/bin/bash

set -e
set -u
set -o pipefail

if [[ ! -f /etc/debian_version ]]; then
  echo "minideb can currently only be built on debian based distros, aborting..."
  exit 1
fi

apt-get update
apt-get install -y \
  debootstrap \
  debian-archive-keyring \
  jq \
  dpkg-dev \
  gnupg \
  ca-certificates \
  curl \
  gpg

