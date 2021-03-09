#!/bin/bash

wget https://github.com/pivotal-cf/om/releases/download/7.2.0/om-linux-7.2.0.tar.gz
tar -xvf om-linux-7.2.0.tar.gz
chmod +x om
rm CHANGELOG.md LICENSE README.md om-linux-7.2.0.tar.gz
sudo mv om /usr/bin/

wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.0/pivnet-linux-amd64-3.0.0
mv pivnet-linux-* pivnet
chmod +x pivnet
sudo mv pivnet /usr/bin/

wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update
sudo apt-get install cf7-cli
rm om