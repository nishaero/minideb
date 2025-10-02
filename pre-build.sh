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

# Fetch and import the latest Debian archive keyring for Trixie support
# Create a temporary directory for key processing
mkdir -p /tmp/debian-keys

# Download Trixie signing keys
curl -fsSL https://ftp-master.debian.org/keys/archive-key-13.asc > /tmp/debian-keys/archive-key-13.asc
curl -fsSL https://ftp-master.debian.org/keys/archive-key-13-security.asc > /tmp/debian-keys/archive-key-13-security.asc

# Export existing keyring to ASCII, import new keys, then convert back to binary
gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --export-options export-minimal --export > /tmp/debian-keys/existing.asc
cat /tmp/debian-keys/archive-key-13.asc /tmp/debian-keys/archive-key-13-security.asc /tmp/debian-keys/existing.asc | gpg --no-default-keyring --keyring /tmp/debian-keys/combined.gpg --import
gpg --no-default-keyring --keyring /tmp/debian-keys/combined.gpg --export-options export-minimal --export | gpg --dearmor > /usr/share/keyrings/debian-archive-keyring.gpg

# Cleanup
rm -rf /tmp/debian-keys
