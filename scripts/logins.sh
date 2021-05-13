#!/bin/bash
# CF cli with TAS info https://docs.pivotal.io/application-service/2-10/cf-cli/getting-started.html

echo "Enter OM Password or Client Secret"
read -r -s OM_PASSWORD

echo "Log in to OM cli"
export OM_USERNAME=[ADMIN]
export OM_PASSWORD=$OM_PASSWORD
# export OM_CLIENT_ID=[ADMIN]
# export OM_CLIENT_SECRET=$OM_PASSWORD
export OM_TARGET=[https://ops-manager...]
export OM_SKIP_SSL_VALIDATION=true

echo "Logging in to bosh and director credhub"
eval "$(om bosh-env)"

echo "Logging in to cf cli"
printf "\nPlease wait a moment while retrieving cf api\n"
CF_API="https://api."$(om staged-config -p cf | grep -A 1 ".cloud_controller.system_domain" | grep value | cut -d ':' -f 2 | sed 's/^ *//g')
CF_USERNAME="admin"
CF_PASSWORD=$(om credentials -p cf -c .uaa.admin_credentials | grep $CF_USERNAME | awk '{printf $4}')
cf login -a "$CF_API" -u "$CF_USERNAME" -p "$CF_PASSWORD" -o system -s system --skip-ssl-validation
