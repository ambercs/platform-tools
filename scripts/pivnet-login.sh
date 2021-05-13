#!/bin/bash
echo "Logging in to pivnet"
echo "Enter Pivnet API Token"
read -r -s API-TOKEN
pivnet login --api-token="$API_TOKEN"