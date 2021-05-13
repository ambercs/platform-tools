#!/bin/bash
# Extra resources https://community.pivotal.io/s/article/how-to-login-and-access-credhub-in-pcf?language=en_US

printf "Enter OM Password or Client Secret"
read -r -s OM_PASSWORD

printf "Log in to OM cli"
export OM_USERNAME=[ADMIN]
export OM_PASSWORD=$OM_PASSWORD
# export OM_CLIENT_ID=[ADMIN]
# export OM_CLIENT_SECRET=$OM_PASSWORD
export OM_TARGET=[https://ops-manager...]
export OM_SKIP_SSL_VALIDATION=true

export BOSH_DIRECTOR_IP=$(om curl -s -p /api/v0/deployed/director/manifest \
| jq '.instance_groups[0].jobs[0].properties.uaa.url' \
| cut -d ':' -f 2 | sed 's/\///g')

printf "Logging in to bosh credhub"
unset $CREDHUB_USERNAME $CREDHUB_PASSWORD $CREDHUB_CLIENT $CREDHUB_SECRET $CREDHUB_SERVER $CREDHUB_CA_CERT
# eval "$(om bosh-env)"
CREDHUB_USERNAME="director"
CREDHUB_PASSWORD=$(om credentials -p p-bosh -c .director.director_credentials | grep $CREDHUB_USERNAME | awk '{printf $4}')
credhub api -s $BOSH_DIRECTOR_IP:8844 --skip-tls-validation
credhub login --username=$CREDHUB_USERNAME --password=$CREDHUB_PASSWORD

printf "Logging in to concourse credhub"
unset $CREDHUB_USERNAME $CREDHUB_PASSWORD $CREDHUB_CLIENT $CREDHUB_SECRET $CREDHUB_SERVER $CREDHUB_CA_CERT
credhub api -s $CONCOURSE_IP:8844 --skip-tls-validation
credhub login --username=$CREDHUB_USERNAME --password=$CREDHUB_PASSWORD
#credhub login --client-name=$CREDHUB_CLIENT --client-secret=$CREDHUB_SECRET
