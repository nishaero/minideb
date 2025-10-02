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

# Download and add Debian Trixie signing keys directly to the keyring
curl -fsSL https://ftp-master.debian.org/keys/archive-key-13.asc | gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --import
curl -fsSL https://ftp-master.debian.org/keys/archive-key-13-security.asc | gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --import
