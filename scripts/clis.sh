#!/bin/bash

# PIVNET CLI #
install=true
NAME="pivnet"
PRODUCT="pivnet-cli"
REPO="pivotal-cf"
FILE_TYPE="linux-amd64"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')

printf "\n\nChecking %s\n" $NAME
if $NAME version ; then
    CURRENT=$($NAME -v)
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
        printf "%s is already up to date, skipping installation" $NAME
    else
        printf "Do you want to upgrade to %s %s?" $NAME "$VERSION"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
            printf "Skipping %s upgrade" $NAME
        fi
    fi
else
    printf "%s is not present on machine, installing now" %NAME
fi

if [[ $install == "true" ]]; then
    printf "Upgrading %s now" $NAME
    printf "Downloading the pivnet cli: https://github.com/pivotal-cf/pivnet-cli/releases \n"

    LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-$FILE_TYPE-%s" "$VERSION" "$VERSION") \
    ; curl -L -o $NAME "$LOCATION"
    chmod +x $NAME
    ./$NAME version
    sudo mv $NAME /usr/local/bin
fi

# OM CLI #
install=true
NAME="om"
PRODUCT="om-linux"
REPO="pivotal-cf"
FILE_TYPE=".tar.gz"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$NAME/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')

printf "\n\nChecking %s\n" $NAME
if $NAME version ; then
    CURRENT=$($NAME -v)
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
        printf "%s is already up to date, skipping installation" $NAME
    else
        printf "Do you want to upgrade to %s %s?" $NAME "$VERSION"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
            printf "Skipping %s upgrade" $NAME
        fi
    fi
else
    printf "%s is not present on machine, installing now" %NAME
fi

if [[ $install == "true" ]]; then
    printf "Upgrading %s now" $NAME
    printf "Downloading the om cli: https://github.com/pivotal-cf/om/releases \n"

    LOCATION=$(printf "https://github.com/$REPO/$NAME/releases/download/%s/$PRODUCT-%s$FILE_TYPE" "$VERSION" "$VERSION") \
    ; curl -L -o $PRODUCT "$LOCATION"
    tar -xvf $PRODUCT
    chmod +x $NAME
    rm CHANGELOG.md LICENSE README.md $PRODUCT
    ./$NAME version
    sudo mv $NAME /usr/local/bin
fi

# BOSH CLI #
install=true
NAME="bosh"
PRODUCT="bosh-cli"
REPO="cloudfoundry"
FILE_TYPE="linux-amd64"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}' \
| sed 's/v//g')

printf "\n\nChecking %s\n" $NAME
if $NAME -v ; then
    CURRENT=$($NAME -v | awk '{printf $2}' | cut -d '-' -f 1)
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
        printf "%s is already up to date, skipping installation" $NAME
    else
        printf "Do you want to upgrade to %s %s?" $NAME "$VERSION"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
            printf "Skipping %s upgrade" $NAME
        fi
    fi
else
    printf "%s is not present on machine, installing now" %NAME
fi

if [[ $install == "true" ]]; then
    printf "Upgrading %s now" $NAME
    printf "Downloading the bosh cli: https://github.com/cloudfoundry/bosh-cli/releases \n"

    LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$PRODUCT-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
    ; curl -L -o $NAME "$LOCATION"
    chmod +x $NAME
    ./$NAME -v
    sudo mv $NAME /usr/local/bin
fi

# CF CLI #
install=true
NAME="cf"
PRODUCT="cli"
REPO="cloudfoundry"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
    | grep "tag_name" \
    | awk '{print substr($2, 2, length($2)-3)}' \
    | sed 's/v//g')

sudo apt-get update
printf "\n\nChecking %s\n" $NAME
if $NAME -v ; then
    CURRENT=$($NAME -v | awk '{printf $3}' | cut -d 'N' -f 1)
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
        printf "%s is already up to date, skipping installation" $NAME
    else
        printf "Do you want to upgrade to %s %s?" $NAME "$VERSION"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
            printf "Skipping %s upgrade" $NAME
        fi
    fi
else
    printf "%s is not present on machine, installing now" %NAME
fi

if [[ $install == "true" ]]; then
    printf "Upgrading %s now" $NAME
    printf "Downloading the cf cli: https://github.com/cloudfoundry/cli/releases \n"

    wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
    echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
    sudo apt-get install cf7-cli
    $NAME version
fi

# CREDHUB CLI #
#if credhub is not installed, go ahead with install
install=true
NAME="credhub"
PRODUCT="credhub-cli"
REPO="cloudfoundry-incubator"
VERSION=$(curl -s https://api.github.com/repos/$REPO/$PRODUCT/releases/latest \
    | grep "tag_name" \
    | awk '{print substr($2, 2, length($2)-3)}' \
    | sed 's/v//g')
FILE="$NAME-linux-$VERSION.tgz"

printf "\n\nChecking %s\n" $NAME
if $NAME --version ; then
    CURRENT=$($NAME --version | awk '{printf $3}' | cut -d 'N' -f 1)
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
        printf "%s is already up to date, skipping installation" $NAME
    else
        printf "Do you want to upgrade to %s %s?" $NAME "$VERSION"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
            printf "Skipping %s upgrade" $NAME
        fi
    fi
else
    printf "%s is not present on machine, installing now" %NAME
fi

if [[ $install == "true" ]]; then
    printf "Upgrading %s now" $NAME
    printf "Downloading the credhub cli: https://github.com/cloudfoundry-incubator/credhub-cli/releases"

    LOCATION=$(printf "https://github.com/%s/%s/releases/download/%s/%s" "$REPO" "$PRODUCT" "$VERSION" "$FILE") \
    ; curl -L -o $NAME "$LOCATION"
    tar -xvf $NAME
    chmod +x $NAME
    ./$NAME --version
    sudo mv $NAME /usr/local/bin
fi

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

printf "\n\nChecking %s\n" $NAME
if $NAME version ; then
    CURRENT=$($NAME -v | awk '{printf $3}')
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
        printf "%s is already up to date, skipping installation" $NAME
    else
        printf "Do you want to upgrade to %s %s?" $NAME "$VERSION"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
            printf "Skipping %s upgrade" $NAME
        fi
    fi
else
    printf "%s is not present on machine, installing now" %NAME
fi

if [[ $install == "true" ]]; then
    printf "Upgrading %s now" $NAME
    printf "Downloading the bbr cli: https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases \n"

    LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
    ; curl -L -o $NAME "$LOCATION"
    chmod +x $NAME
    ./$NAME version
    sudo mv $NAME /usr/local/bin
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

printf "\n\nChecking %s\n" $NAME
if $NAME -v ; then
    CURRENT=$($NAME -v)
    if [ "$VERSION" == "$CURRENT" ]; then
        install=false
        printf "%s is already up to date, skipping installation" $NAME
    else
        printf "Do you want to upgrade to %s %s?" $NAME "$VERSION"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
            install=false
            printf "Skipping %s upgrade" $NAME
        fi
    fi
else
    printf "%s is not present on machine, installing now" %NAME
fi

if [[ $install == "true" ]]; then
    printf "Upgrading %s now" $NAME
    printf "Downloading the fly cli: https://github.com/concourse/concourse/releases \n"

    LOCATION=$(printf "https://github.com/$REPO/$PRODUCT/releases/download/v%s/$NAME-%s-$FILE_TYPE" "$VERSION" "$VERSION") \
    ; curl -L -o $NAME "$LOCATION"
    tar -xvf $NAME
    chmod +x $NAME
    ./$NAME -v
    sudo mv $NAME /usr/local/bin
fi
