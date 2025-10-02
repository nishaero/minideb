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

# Fetch the latest Debian archive keyring for Trixie support
curl -fsSL https://ftp-master.debian.org/keys/archive-key-13.asc | gpg --dearmor -o /usr/share/keyrings/debian-archive-keyring-trixie.gpg
curl -fsSL https://ftp-master.debian.org/keys/archive-key-13-security.asc | gpg --dearmor >> /usr/share/keyrings/debian-archive-keyring-trixie.gpg

# Merge with existing keyring
cat /usr/share/keyrings/debian-archive-keyring-trixie.gpg >> /usr/share/keyrings/debian-archive-keyring.gpg
