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

# Download and install the latest debian-archive-keyring package from Debian unstable
# This includes the Trixie signing keys
curl -fsSL http://deb.debian.org/debian/pool/main/d/debian-archive-keyring/debian-archive-keyring_2023.4_all.deb -o /tmp/debian-keyring.deb
sudo dpkg -i /tmp/debian-keyring.deb
rm /tmp/debian-keyring.deb
