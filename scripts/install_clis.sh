#!/bin/bash
echo "Select team to fly pipelines:
1. macOS
2. linux"
read -r selection

if [ "$selection" == "1" ] || [ "$selection" == "macOS" ] || [ "$selection" == "mac" ]; then
    OS=darwin
else
    OS=linux
fi

# PIVNET CLI #
NAME="pivnet"
PRODUCT="pivnet-cli"
REPO="pivotal-cf"
FILE_TYPE="$OS-amd64"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')

printf "\n\nInstalling %s cli\n" $NAME
printf "Downloading the %s cli: https://github.com/%s/%s/releases \n" $NAME $REPO $PRODUCT

LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-$FILE_TYPE-%s" "$VERSION" "$VERSION") \
; curl -L -o $NAME "$LOCATION"
chmod +x $NAME
./$NAME version
sudo mv $NAME /usr/local/bin

# OM CLI #
NAME="om"
PRODUCT="om-$OS"
REPO="pivotal-cf"
FILE_TYPE=".tar.gz"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$NAME/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')

printf "\n\nInstalling %s cli\n" $NAME
printf "Downloading the %s cli: https://github.com/%s/%s/releases \n" $NAME $REPO $PRODUCT

LOCATION=$(printf "https://github.com/$REPO/$NAME/releases/download/%s/$PRODUCT-%s$FILE_TYPE" "$VERSION" "$VERSION") \
; curl -L -o $PRODUCT "$LOCATION"
tar -xvf $PRODUCT
chmod +x $NAME
rm CHANGELOG.md LICENSE README.md $PRODUCT
./$NAME version
sudo mv $NAME /usr/local/bin

# BOSH CLI #
NAME="bosh"
PRODUCT="bosh-cli"
REPO="cloudfoundry"
FILE_TYPE="$OS-amd64"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')

printf "\n\nInstalling %s cli\n" $NAME
printf "Downloading the %s cli: https://github.com/%s/%s/releases \n" $NAME $REPO $PRODUCT

LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$PRODUCT-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
; curl -L -o $NAME "$LOCATION"
chmod +x $NAME
./$NAME -v
sudo mv $NAME /usr/local/bin

# CF CLI #
NAME="cf"
PRODUCT="cli"
REPO="cloudfoundry"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
    | grep "tag_name" \
    | awk '{print substr($2, 2, length($2)-3)}' \
    | sed 's/v//g')

printf "\n\nInstalling %s cli\n" $NAME
printf "Downloading the %s cli: https://github.com/%s/%s/releases \n" $NAME $REPO $PRODUCT

if [[ $OS == darwin ]]; then
    brew update
    brew install cloudfoundry/tap/cf-cli@6
    $NAME -v
else
    wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
    echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
    sudo apt-get update
    sudo apt-get install cf7-cli
    $NAME -v
fi

# CREDHUB CLI #
#if credhub is not installed, go ahead with install
NAME="credhub"
PRODUCT="credhub-cli"
REPO="cloudfoundry-incubator"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
    | grep "tag_name" \
    | awk '{print substr($2, 2, length($2)-3)}' \
    | sed 's/v//g')
FILE="$NAME-$OS-$VERSION.tgz"

printf "\n\nInstalling %s cli\n" $NAME
printf "Downloading the %s cli: https://github.com/%s/%s/releases \n" $NAME $REPO $PRODUCT

LOCATION=$(printf "https://github.com/%s/%s/releases/download/%s/%s" "$REPO" "$PRODUCT" "$VERSION" "$FILE") \
; curl -L -o $NAME "$LOCATION"
tar -xvf $NAME
chmod +x $NAME
./$NAME --version
sudo mv $NAME /usr/local/bin

# BBR CLI #
#if bbr is not installed, go ahead with install
NAME="bbr"
PRODUCT="bosh-backup-and-restore"
REPO="cloudfoundry-incubator"
FILE_TYPE="$OS-amd64"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
    | grep "tag_name" \
    | awk '{print substr($2, 2, length($2)-3)}' \
    | sed 's/v//g')

printf "\n\nInstalling %s cli\n" $NAME
printf "Downloading the %s cli: https://github.com/%s/%s/releases \n" $NAME $REPO $PRODUCT

LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
; curl -L -o $NAME "$LOCATION"
chmod +x $NAME
./$NAME version
sudo mv $NAME /usr/local/bin

# FLY CLI #
NAME="fly"
PRODUCT="concourse"
REPO="concourse"
FILE_TYPE="$OS-amd64.tgz"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')

printf "\n\nInstalling %s cli\n" $NAME
printf "Downloading the %s cli: https://github.com/%s/%s/releases \n" $NAME $REPO $PRODUCT

LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
; curl -L -o $NAME "$LOCATION"
tar -xvf $NAME
chmod +x $NAME
./$NAME -v
sudo mv $NAME /usr/local/bin
