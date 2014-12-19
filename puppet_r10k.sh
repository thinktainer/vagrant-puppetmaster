#!/usr/bin/env bash
#
# This installs r10k and pulls the modules for continued installation
#
# We cannot handle failures gracefully here
set -e

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi


echo "Updating package cache"
yum makecache >/dev/null

echo "Updating system"
yum update -y > /dev/null

echo "Installing git..."
yum install -y git >/dev/null

echo "Installing r10k..."
gem install --no-rdoc --no-ri r10k >/dev/null

echo "Running r10k to fetch modules for puppet provisioner..."
cp /vagrant/VagrantConf/Puppetfile .
r10k puppetfile install

