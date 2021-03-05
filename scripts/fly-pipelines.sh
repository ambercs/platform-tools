#!/usr/bin/env bash
# Get base dir of repo for later use
pushd $(dirname $0) >/dev/null 2>&1
    BASEDIR=$(git rev-parse --show-toplevel)
popd >/dev/null 2>&1

echo "Make sure that you are portforwarding, run:
$ kubectl port-forward service/concourse-web 8080
"
if [ -z "$1" ]; then
    echo "Select team to fly pipelines:
    1. sandbox
    2. dev
    3. prod"
    read -r selection
else
    selection=$1
fi

if [ "$selection" == "1" ] || [ "$selection" == "sandbox" ]; then
    TEAM=sandbox
elif [ "$selection" == "2" ] || [ "$selection" == "dev" ]; then
    TEAM=dev
elif [ "$selection" == "3" ] || [ "$selection" == "prod" ]; then
    TEAM=prod
else
    echo "No team selected, quitting"
    exit
fi

URL=http://concourse-web.default.svc.cluster.local:8080
TARGET=$(fly targets | grep $URL | grep $TEAM | head -n1 | awk '{print $1;}')

echo "Flying piplines for target "$TARGET", continue? y/n"
read -r response
if [ "$response" != "y" ] && [ "$response" != "yes" ]; then
    echo "Ok, quitting"
    exit
fi

set -ex

fly -t "$TARGET" set-pipeline -p cert-expiry \
    -c ${BASEDIR}/pipelines/cert-expiry-pipeline.yml \
    -l ${BASEDIR}/environments/aws/"$TEAM"/pipeline-vars/global.yml

fly -t "$TARGET" set-pipeline -p rotate-certificates \
    -c ${BASEDIR}/pipelines/rotate-certificates-pipeline.yml \
    -l ${BASEDIR}/environments/aws/"$TEAM"/pipeline-vars/global.yml

${BASEDIR}/scripts/flytt.sh patch-pipeline "$TEAM" "$TARGET" \
    -l ${BASEDIR}/environments/aws/"$TEAM"/pipeline-vars/global.yml \
    -v changes-allowed=false -v debug=false \
    -v send-notification=true -v exclude-tas-components=false \
    -v git-branch=main

${BASEDIR}/scripts/flytt.sh upgrade-pipeline "$TEAM" "$TARGET" \
    -l ${BASEDIR}/environments/aws/"$TEAM"/pipeline-vars/global.yml \
    -v changes-allowed=true -v debug=false

set +ex

if [ $TEAM == "sandbox" ]; then

    set -ex
    fly -t "$TARGET" sp -p get-latest-versions \
        -c ${BASEDIR}/pipelines/get-latest-versions-pipeline.yml \
        -l ${BASEDIR}/pipelines/vars/get-latest-versions.yml \
        -l ${BASEDIR}/environments/aws/"$TEAM"/pipeline-vars/global.yml \
        -l ${BASEDIR}/environments/aws/"$TEAM"/config-director/vars/director.yml \

    fly -t "$TARGET" sp -p start-stop-foundation \
        -c ${BASEDIR}/pipelines/start-stop-environment-pipeline.yml \
        -l ${BASEDIR}/environments/aws/"$TEAM"/pipeline-vars/global.yml \
        -l ${BASEDIR}/environments/aws/"$TEAM"/config-director/vars/director.yml

    fly -t "$TARGET" sp -p check-open-prs \
        -c ${BASEDIR}/pipelines/check-open-prs-pipeline.yml

fi
