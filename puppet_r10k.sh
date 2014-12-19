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

apt-get update >/dev/null

echo "Installing ruby 1.9.3..."
apt-get install -y  \
	 \
	build-essential libopenssl-ruby1.9.1 libssl-dev zlib1g-dev >/dev/null

DEBIAN_FRONTEND=noninteractive apt-get -y \
	-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
	install ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 \
	build-essential libopenssl-ruby1.9.1 libssl-dev zlib1g-dev >/dev/null

echo "Installing git..."
apt-get install -y git >/dev/null

echo "Installing r10k..."
gem install r10k -y >/dev/null

echo "Running r10k to fetch modules for puppet provisioner..."
cp /vagrant/VagrantConf/Puppetfile .
r10k puppetfile install
