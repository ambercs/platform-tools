#!/bin/bash

# PIVNET CLI #
printf "Downloading the pivnet cli: https://github.com/pivotal-cf/pivnet-cli/releases \n"
NAME="pivnet"
PRODUCT="pivnet-cli"
REPO="pivotal-cf"
FILE_TYPE="linux-amd64"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')
LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-$FILE_TYPE-%s" "$VERSION" "$VERSION") \
; curl -L -o $NAME "$LOCATION"
chmod +x $NAME
./$NAME version
mv $NAME /usr/local/bin

# OM CLI #
printf "Downloading the om cli: https://github.com/pivotal-cf/om/releases \n"
NAME="om"
PRODUCT="om-linux"
REPO="pivotal-cf"
FILE_TYPE=".tar.gz"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$NAME/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')
LOCATION=$(printf "https://github.com/$REPO/$NAME/releases/download/%s/$PRODUCT-%s$FILE_TYPE" "$VERSION" "$VERSION") \
; curl -L -o $PRODUCT "$LOCATION"
tar -xvf $PRODUCT
chmod +x $NAME
rm CHANGELOG.md LICENSE README.md $PRODUCT
./$NAME version
sudo mv $NAME /usr/local/bin

# BOSH CLI #
printf "Downloading the bosh cli: https://github.com/cloudfoundry/bosh-cli/releases \n"
NAME="bosh"
PRODUCT="bosh-cli"
REPO="cloudfoundry"
FILE_TYPE="linux-amd64"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')
LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$PRODUCT-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
; curl -L -o $NAME "$LOCATION"
chmod +x $NAME
./$NAME -v
mv $NAME /usr/local/bin

# CF CLI #
printf "Downloading the cf cli: https://github.com/cloudfoundry/cli/releases \n"
NAME="cf"
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update
sudo apt-get install cf7-cli
$NAME version

# CREDHUB CLI #

# BBR CLI #
#if bbr is not installed, go ahead with install
install=true
NAME="bbr"
PRODUCT="bosh-backup-and-restore"
REPO="cloudfoundry-incubator"
FILE_TYPE="linux-amd64"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
    | grep "tag_name" \
    | awk '{print substr($2, 2, length($2)-3)}' \
    | sed 's/v//g')

if $NAME -v ; then
    CURRENT=$($NAME -v | awk '{printf $3}')
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
    else
        echo "Do you want to upgrade to $VERSION?"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
        fi
    fi
fi

if [ $install == "true" ]; then
    printf "Downloading the bbr cli: https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases \n"

    LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
    ; curl -L -o $NAME "$LOCATION"
    chmod +x $NAME
    ./$NAME version
    mv $NAME /usr/local/bin
fi

# FLY CLI #
install=true
NAME="fly"
PRODUCT="concourse"
REPO="concourse"
FILE_TYPE="linux-amd64.tgz"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')

if $NAME -v ; then
    CURRENT=$($NAME -v | awk '{printf $3}')
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
    else
        echo "Do you want to upgrade to $VERSION?"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
        fi
    fi
fi

if [ $install == "true" ]; then
    printf "Downloading the fly cli: https://github.com/concourse/concourse/releases \n"

    LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
    ; curl -L -o $NAME "$LOCATION"
    chmod +x $NAME
    ./$NAME -v
    mv $NAME /usr/local/bin
fi