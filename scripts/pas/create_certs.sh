#!/bin/bash

set -e
echo "Enter sys domain and app domain"
if [[ ($# -ne 2) ]]; then
    echo "Wrong number of arguments:"
    exit 1
fi

SYS_DOMAIN=$1
APP_DOMAIN=$2

SSL_FILE=sslconf-${SYS_DOMAIN}.conf

#Generate SSL Config with SANs
if [ ! -f "$SSL_FILE" ]; then
 cat > "$SSL_FILE" <<EOM
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
[req_distinguished_name]
#countryName = Country Name (2 letter code)
#countryName_default = US
#stateOrProvinceName = State or Province Name (full name)
#stateOrProvinceName_default = TX
#localityName = Locality Name (eg, city)
#localityName_default = Frisco
#organizationalUnitName     = Organizational Unit Name (eg, section)
#organizationalUnitName_default   = Pivotal Labs
#commonName = Pivotal
#commonName_max = 64
[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = critical, CA:true
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment, cRLSign, keyCertSign
subjectKeyIdentifier = hash
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${SYS_DOMAIN}
DNS.2 = *.login.${SYS_DOMAIN}
DNS.3 = *.uaa.${SYS_DOMAIN}
DNS.4 = *.${APP_DOMAIN}
EOM
fi

openssl genrsa -out "${SYS_DOMAIN}".key 2048
openssl req -new -out "${SYS_DOMAIN}".csr -subj "/CN=*.${SYS_DOMAIN}/O=Pivotal/C=US" -key "${SYS_DOMAIN}".key -config "${SSL_FILE}"
openssl req -text -noout -in "${SYS_DOMAIN}".csr
openssl x509 -req -days 3650 -in "${SYS_DOMAIN}".csr -signkey "${SYS_DOMAIN}".key -out "${SYS_DOMAIN}".crt -extensions v3_req -extfile "${SSL_FILE}"
openssl x509 -in "${SYS_DOMAIN}".crt -text -noout