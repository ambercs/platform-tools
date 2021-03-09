Troubleshooting:
    DNS
    Firewall
    Certs
    MTU
    NTP
    https://docs.pivotal.io/ops-manager/2-10/install/trouble-advanced.html
    cd /var/vcap/bosh/log

If you need to generate certs, check this out:
    Certstrap: https://github.com/square/certstrap
    CreateCert Script: https://gist.github.com/zmb3/07c0aa6e5cd571c39f8d9963ba792f4e

Where to find all envs and creds,...and ways to store them and use them for login
Om, cf, bosh



-------------------------------------------------------------------------------------------------------------------------------
PKS CLI
-------------------------------------------------------------------------------------------------------------------------------
How to target
You can get the password for PKS_UAA_Management_Admin_Client from the PKS tile credentials in OM
Run > pks login -a api.pks.haas-402.pez.pivotal.io --client-name admin --client-secret <PKS_UAA_Management_Admin_Client> --skip-ssl-validation

Useful commands
> pks create cluster

-------------------------------------------------------------------------------------------------------------------------------
Kubectl CLI
-------------------------------------------------------------------------------------------------------------------------------
Here manage the pods etc in your cluster
How to Target
> pks get-credentials alpha-cluster (or other cluster name)
> kubectl config use-context alpha-cluster
> kubectl config view

-------------------------------------------------------------------------------------------------------------------------------
CF CLI
-------------------------------------------------------------------------------------------------------------------------------
How to target
 > cf login [-a API_URL] [-u USERNAME] [-p PASSWORD] [-o ORG] [-s SPACE] --skip-ssl-validation
Where do i get the:
	Api url: api.run.<domain_name> or api.sys.<domain_name>
Username: opsman -> pas tile -> credentials -> UAA -> admin credentials
Password: opsman -> pas tile -> credentials -> UAA -> admin credentials

Useful commands
> cf help -a
> cf push
> cf scale
> cf logs
> cf routes
> cf target -o “<org-name>” -s “<space-name>”  	target the correct org and space
> cf target						Check which org/space you are in
> cf apps 						view apps in appsman
> cf app <app-name>					view info/health about app
> cf logs <app-name> 				view logs from app `--recent` tag won’t tail
> cf top 				interact with all of the apps running in cf (is a plugin)
> cf buildpacks 			available buildpacks, different for each app language
> cf push 			launch app, saves changes, can use url to view running app
> cf restart <app-name> 				relaunch the app
> cf scale -i 2 <app-name> 				scale the number of instances up to 2 total
> cf stacks						stacks available
> cf marketplace			services available in cf (can also view with appsman gui)
> cf create-service <service-from-marketplace> <plan> <service-instance-name> instance
> cf services						show the service that you just created
> cf service <name>					info about your newly created service
> cf bind-service <app> <service-instance-name>
> cf restage <app name>
> cf env						list the env config
> cf orgs						list the available orgs
> cf org <org-name>					list details about the org
> cf quotas						list the available created quotas
> cf quota <quota-name>				details about the available quota
> cf create-org <org-name> -q <quota-name>	creates a new org, no quota is default
> cf create-user <new-user-name> <password-from-pez>
> cf set-space-role <new-user-name> <org> <space> SpaceDeveloper
> cf space-users <org> <space>			users for the space
> cf update-quota <quota-namee> -r 20
> cf domains						available domains in the org


-------------------------------------------------------------------------------------------------------------------------------BOSH CLI
--------------------------------------------------------------------------------------------------------------------------------
How to target
> source <file>
> export <var>=<value>
> bosh env will verify your environment

Bc whew https://ultimateguidetobosh.com/targeting-bosh-envs/
A couple options for making sure that you are targeting the correct environment
Create a bosh_env.sh file and `> source` it in each terminal instance
Individually `export <VAR>=<value>` for each environment variable that you want to set

For a more permanent option, can (1) source the path to the bosh_env.sh file in the bash profile, or (2) explicitly define each environment variable in your bash profile
(PREFERRED) Run an alias
> alias bosh="BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET=FVsME_gCfIB7HBRQjB5fq_aDl3uP_wzT BOSH_CA_CERT=./cert.pem  BOSH_ENVIRONMENT=10.0.0.11 bosh "


Where do I get the:
Will need a few environment variables in order to connect to the bosh director:

Opsman -> bosh director tile -> credentials -> bosh command line credentials

BOSH_ENVIRONMENT 	describes the director environment name or URL.
BOSH_CLIENT 		is the username to authenticate with the BOSH director.
BOSH_CLIENT_SECRET 	is the password for the username above.
BOSH_CA_CERT		represents the director CA certificate path or value.

Targeting BOSH with different envs and opsmans
make sure that you are targeting the correct om (ie controlplane vs sandbox)...both when you run om bosh-envs and when you do the alias
-get credentials from om bosh-env
-get credentials from bosh director tile

ACCESS SANDBOX
> alias bosh="BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET=e3qH9zGBEJm5g9AhxqKxxxTDHcRqL3-H BOSH_CA_CERT=./bosh_ca_cert_sandbox.pem BOSH_ENVIRONMENT=192.168.1.11 bosh "

BOSH TO ACCESS CONTROL PLANE
> alias bosh="BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET=brUxctUtX_OvI15sgJzhgjisCmUVHT_M BOSH_CA_CERT=./bosh_ca_cert_controlplane.pem BOSH_ENVIRONMENT=192.168.0.11 bosh "

Useful commands
> bosh releases
> bosh instances
> bosh stemcells
> bosh instances
> bosh instances -ps
> bosh errands
> bosh deployments
> bosh cloud-config > cloud.yml
> bosh ssh -d <deployment> <instance>/<id or index>
once you install pas, one of these will be cf
> cd into /var/vcap to get info on the vm
Within vms can find stderr/out.log and troubleshoot those

	**when you are in bosh ssh, go to /var/vcap/… to view anything about the instance

Monit summary
> bosh logs (-f)
> bosh tasks
> bosh task <task-number>
> bosh cck -d <deployment-name> -r (cloud check)
> bosh cck -d <deployment-name> (cloud check +help how to fix)
> bosh vms
> bosh vms --vitals
> bosh variables
> bosh cloud-config !!!
> bosh deploy (-e env path or -v variable path) -d <deployment> ./<path to manifest>
> sv stop agent
stop BOSH agent within VM

Accessing Bosh - when networks are not connected
Soooo the network with jumpbox (default) may not know about the network with all of the subnets (pas, deployment, infrastructure). You will have to do a thing called “peering”

1.  Configure bi-directional VPC Network Peering between the default
  		 network and the PCF_SUBDOMAIN_NAME-pcf-network.

>  gcloud compute networks peerings create  default-to-${PCF_SUBDOMAIN_NAME}-pcf-network \
   		  --network=default \
     		  --peer-network=${PCF_SUBDOMAIN_NAME}-pcf-network \
     		  --auto-create-routes

 > gcloud compute networks peerings create ${PCF_SUBDOMAIN_NAME}-pcf-network-to-default \
     --network=${PCF_SUBDOMAIN_NAME}-pcf-network \
     --peer-network=default \
     --auto-create-routes

1.  The main purpose of this modification is to allow tools on the
   jumpbox (e.g. the BOSH cli) to talk to the BOSH Director VM.
   We will finalise this change by opening three key ports on the
   Firewall. The BOSH director’s primary port is 25555 and it supports websocket
   streaming on port 8443.
   The BBR tool (which we will encounter later) requires SSH access on
   port 22.

   	> gcloud compute --project=${PCF_PROJECT_ID} firewall-rules create bosh \
   		 --direction=INGRESS \
    --priority=1000 \
    --network=${PCF_SUBDOMAIN_NAME}-pcf-network \
    --action=ALLOW \
    --rules=tcp:25555,tcp:8443,tcp:22 \
    --source-ranges=0.0.0.0/0

Side note, some nice setup
Ensure correct ownership of bosh directory
> sudo chown -R ubuntu:ubuntu ~/.bosh
> om bosh-env --help
> eval "$(om bosh-env --ssh-private-key /home/ubuntu/workspace/my-keys/om_ssh_key)" (change the path to the key that you set up in the beginning for opsman)
...source your ~/.bashrc file. From now on, the credhub and bosh CLIs will point to their respective servers and from now on will just work
… > om bosh-env will tell you the details for accessing bosh and credhub

-------------------------------------------------------------------------------------------------------------------------------
JUMPBOX
-------------------------------------------------------------------------------------------------------------------------------
Create a jumpbox
> gcloud compute instances create "jumpbox" \
  --image-family "ubuntu-1804-lts" \
  --image-project "ubuntu-os-cloud" \
  --boot-disk-size "200" \
  --zone us-central1-a

> gcloud compute ssh unbuntu@jumpbox into the jumpbox
> gcloud config set project pasfun0806-asalome-pivotal-io <projeect name>

Set up jumpbox env
Create .env file with these values from the google console

PCF_PIVNET_UAA_TOKEN=CHANGE_ME_PCF_PIVNET_UAA_TOKEN
# see https://network.pivotal.io/users/dashboard/edit-profile
PCF_DOMAIN_NAME=pal4pe.com
PCF_SUBDOMAIN_NAME=CHANGE_ME_SUBDOMAIN_NAME
 # e.g. instructor will assign you one
PCF_OPSMAN_ADMIN_PASSWD=CHANGE_ME_OPSMAN_ADMIN_PASSWD
# e.g. for simplicity, recycle your PCF_PIVNET_UAA_TOKEN
PCF_PROJECT_ID=$(gcloud config get-value core/project)
PCF_OPSMAN_FQDN=ops-manager.${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}

Is useful to source ${PIVNET_TOKEN} and ${HAAS_NUM} as well

> source ~/.env
> echo "source ~/.env" >> ~/.bashrc

Partially type and hit up or down to autocomplete
Add to ~/.inputrc (so that you can partially type and hit up or down to autocomplete)
	“\e[A”: history-search-backward
	“\e[B”: history-search-forward

And install tools
sudo apt update
sudo apt --yes install unzip
sudo apt --yes install jq

wget -O terraform.zip https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip &&
  unzip terraform.zip &&  sudo mv terraform /usr/local/bin
wget -O om https://github.com/pivotal-cf/om/releases/download/3.1.0/om-linux-3.1.0 &&  chmod +x om && sudo mv om /usr/local/bin/
wget -O bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v6.0.0/bosh-cli-6.0.0-linux-amd64 && chmod +x bosh && sudo mv bosh /usr/local/bin/
wget -O bbr https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v1.5.1/bbr-1.5.1-linux-amd64 && chmod +x bbr &&  sudo mv bbr /usr/local/bin/
wget -O pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.60/pivnet-linux-amd64-0.0.60 && chmod +x pivnet && sudo mv pivnet /usr/local/bin/

Or vsphere preinstalled just run
> cd ~
> mkdir workspace

#download pivnet cli
> wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.60/pivnet-linux-amd64-0.0.60
> sudo chmod +x pivnet-*
> sudo mv pivnet-* /usr/local/bin/pivnet
> pivnet -version

#download fly cli
> wget https://github.com/concourse/concourse/releases/download/v4.2.3/fly_linux_amd64
> mv fly_* fly
> sudo chmod +x fly
> sudo mv fly /usr/local/bin/
> fly --help

#download credhub cli
> wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.5.2/credhub-linux-2.5.2.tgz
> tar xvzf *tgz
> rm *tgz
> mv credhub* credhub
> sudo chmod +x credhub
> sudo mv credhub /usr/local/bin/
> credhub --help

#download minio cli
> wget https://dl.min.io/client/mc/release/linux-amd64/mc
> mv mc* mc
> sudo chmod +x mc
> sudo mv mc /usr/local/bin/
> mc --help

#download terraform cli
> sudo snap install terraform
> terraform --help

#download om cli
> wget https://github.com/pivotal-cf/om/releases/download/3.1.0/om-linux-3.1.0
> mv om* om
> sudo chmod +x om
> sudo mv om /usr/local/bin/
> om --help

Edit DNS to accommodate control plane -> add these entries
Login as haas-#-user
Pez password
ops-manager.controlplane.haas-${HAAS_NUM}.pez.pivotal.io: 10.xxx.zzz.30
plane.controlplane.haas-${HAAS_NUM}.pez.pivotal.io: 10.xxx.zzz.32
uaa.controlplane.haas-${HAAS_NUM}.pez.pivotal.io: 10.xxx.zzz.32
credhub.controlplane.haas-${HAAS_NUM}.pez.pivotal.io: 10.xxx.zzz.32
minio.controlplane.haas-${HAAS_NUM}.pez.pivotal.io: 10.xxx.zzz.33

Change opsmgr-01 and *.run, *.cfapps to.
ops-manager.sandbox.haas-${HAAS_NUM}.pez.pivotal.io: 10.xxx.zzz.16
*.apps.sandbox.haas-${HAAS_NUM}.pez.pivotal.io: 10.xxx.zzz.17
*.sys.sandbox.haas-${HAAS_NUM}.pez.pivotal.io: 10.xxx.zzz.17

-------------------------------------------------------------------------------------------------------------------------------
PIVNET CLI
-------------------------------------------------------------------------------------------------------------------------------
How to target
> pivnet login --api-token=${PIVNET_TOKEN} …..pivnet_token_from_user_info

Useful commands
> pivnet product-files
> pivnet accept-eula
> pivnet download-product-files

How to find and download your product
> pivnet products | grep <name>		to get the specific name of the product (or stemcell)
> pivnet product -p <slug>		to get the specific name of the product (or stemcell)
> pivnet releases -p <slug>				to get the release that you want
> pivnet product-files -p <slug> -r <release>	to get the product id
> pivnet download-product-files -p <name> -r <release> -i <id> --accept-eula	to download
> pivnet release-dependencies -p <name> -r <release> 		        For any dependencies
(then use om to upload -> om -e <env.yml> upload-product -p <path-to-product>


OPEN SSL CONFIGURATION
How to self-sign cert
cat > ./${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}.cnf <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=US
ST=Colorado
L=Boulder
O=PIVOTAL, INC.
OU=EDUCATION
CN = ${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = *.sys.${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}
DNS.2 = *.login.sys.${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}
DNS.3 = *.uaa.sys.${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}
DNS.4 = *.apps.${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}
EOF

Create key and cert with the openssl
openssl req -x509 -newkey rsa:2048 -nodes \
-keyout ${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}.key \
-out ${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}.cert \
-config ./${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}.cnf

--------------------------------------------------------------------------------------------------------------------------------
TERRAFORM CLI
--------------------------------------------------------------------------------------------------------------------------------
Using terraform to pave the IAAS https://courses.education.pivotal.io/c/349803189/pas-fundamentals-install-opsmanager-director-pas/deploy-ops-manager/index.html
Create terraform.tfvars file
Can get more vars from the terraform readme
env_name          	= "PCF_SUBDOMAIN_NAME"
project             	= "PCF_PROJECT_ID" - project id on gcp
region             		= "us-central1"
zones              	= ["us-central1-b", "us-central1-a", "us-central1-c"]
dns_suffix         	= "PCF_DOMAIN_NAME"
opsman_image_url    	= ""
create_gcs_buckets  	= "false"
external_database  	= 0
ssl_cert = <<SSL_CERT
-----BEGIN CERTIFICATE-----
YOUR_SSL_CERT --- from PCF_SUBDOMAIN_NAME.PCF_DOMAIN_NAME.cert file.
-----END CERTIFICATE-----
SSL_CERT

ssl_private_key = <<SSL_KEY
-----BEGIN RSA PRIVATE KEY-----
YOUR_PRIVATE_KEY --- from PCF_SUBDOMAIN_NAME.PCF_DOMAIN_NAME.key
-----END RSA PRIVATE KEY-----
SSL_KEY

service_account_key = <<SERVICE_ACCOUNT_KEY
YOUR_SERVICE_ACCOUNT_KEY - gcp_credentials.json
SERVICE_ACCOUNT_KEY

Useful commands
> terraform init
> terraform plan -out=plan
> terraform apply --auto-approve
> terraform output > output.txt

--------------------------------------------------------------------------------------------------------------------------------
OM CLI
-------------------------------------------------------------------------------------------------------------------------------- "$(om -e secrets/control/env.yml bosh-env -i secrets/control/opsman_control.pem)"
How to target (3 ways)
> om --target <pcf_opsman_fdqn> --username <admin> --password <password> --skip-ssl-validation ….<rest of command>

 Rather than typing this in every time, you can create an om_env.yml and do
`> om -e om_env.yml <command>`

> om_env.yml
	> target: <opsman.salome.pal4pe.com>
	> username: admin or whatever you set it to
	> password: admin or whatever you set it to
	> skip-ssl-validation : true

OR you can export the variables and/or make an sh file that you source (via command line or in .bashrc)

> om_env.sh
	> export OM_USERNAME=admin
	> export OM_PASSWORD=password
	> export ROOT_DOMAIN=controlplane.haas-{$HAAS_NUM}.pez.pivotal.io
	> export OM_TARGET=https://ops-managere.{$ROOT_DOMAIN}
	> export OM_SKIP_SSL_VALIDATION=true

You may be targeting more than one opsman, so it can be useful to have different env files to switch between

Useful commands
> om upload-product --product <name>
> om --request-timeout 7200 upload-product  --product <file>.pivotal
> om upload-stemcell --stemcell <name>
> om <-e env> bosh-env - grab the details you need to log in to the bosh cli
> om deployed-products
> om -k certificate-authorities --format json
> om --skip-ssl-validation generate-certificate \
 --domains "uaa.${ROOT_DOMAIN},credhub.${ROOT_DOMAIN}, plane.${ROOT_DOMAIN}" > ./om_generated_cert.json
> om configure-authentication --decryption-passphrase "${OM_PASSWORD}"
> om configure-director --config "/tmp/p_automator_config/director_config.yml"
> om config-template \
    --output-directory <dir> \
    --pivnet-api-token ${PIVNET_API_TOKEN} \
    --pivnet-product-slug <slug> \
    --product-version <version>
> om interpolate --config ./product.yml \
    --vars-file ./product-default-vars.yml \
    --vars-file ./resource-vars.yml \
    --vars-file ./errand-vars.yml \
    --ops-file ./features/boshtasks-disable.yml \
    --ops-file ./optional/add-healthwatch-forwarder-foundation_name.yml \
    --ops-file ./optional/add-healthwatch-forwarder-health_check_vm_type.yml

General flow for product config and deployment
Same process, upload product and stemcell
> om available-products
> om stage-product
> om interpolate config template and vars file into config file
> om configure-product
> om appy-changes

Extract current config that is set up in opsman
> om staged-config -p <product-name> --include-placeholders (-r or -c also) >> <name>.yml

Configure access to control plane BOSH and Credhub
> eval “$(om bosh-env --ssh-private-key /home/ubuntu/workspace/keys/cp_opsman_key)”

Advanced OM debugging
Can end the /debug endpoint on the end of the opsman yml...then click on rails logs to get an idea of what went wrong for troubleshooting

-------------------------------------------------------------------------------------------------------------------------------

UAAC CLI
--------------------------------------------------------------------------------------------------------------------------------
Installation
	> sudo apt install --yes build-essential && \
	> sudo apt install --yes ruby-dev && \
	> sudo gem install --no-ri --no-rdoc cf-uaac

...if you are having trouble, go here
https://stackoverflow.com/questions/13767725/unable-to-install-gem-failed-to-build-gem-native-extension-cannot-load-such
sudo apt install build-essential
sudo apt-get install ruby-dev
sudo apt-get install make
sudo apt-get install zlibc zlib1g zlib1g-dev

Add credhubhub client in UAA
	> uaac target uaa.controlplane.haas-${HAAS_NUM}.pez.pivotal.io:8443 --skip-ssl-valida
	> uaac token client get  (login with admin and ${UAA_ADMIN_PWD}
> uaac client add --name ${CLIENT_NAME} --scope uaa.none --authorized_grant_types client_credentials --authorities “credhub.write,credhub.read”
> (now login with ${CLIENT_NAME} and new secret)

Set (new) client permissions (see credhub)

PKS UAAC
uaac target https://api.pks.haas-#.pez.pivotal.io:8443 --ca-cert api.crt --skip-ssl-validation
uaac token client get admin
uaac user add <name> --email asalome@pivotal.io
uaac member add pks.clusters.admin <name>


--------------------------------------------------------------------------------------------------------------------------------
CREDHUB CLI
--------------------------------------------------------------------------------------------------------------------------------
How to target (with concourse as an example)
Make a script to specifically target the concourse credhub on the credhub target variables
> unset CREDHUB_PROXY
> export CREDHUB_SERVER="${CONCOURSE_CREDHUB_SERVER}"
> export CREDHUB_CLIENT=${CONCOURSE_CREDHUB_CLIENT}
> export CREDHUB_SECRET=${CONCOURSE_CREDHUB_SECRET}
> export CREDHUB_CA_CERT="${CONCOURSE_CREDHUB_CA_CERT}"
> credhub login

> unset CREDHUB_PROXY
> export CREDHUB_SERVER=”https://credhub.$ROOT_DOMAIN}:8844”
> export CREDHUB_CLIENT=”credhub_admin_client”
> export CREDHUB_SECRET=
> export CREDHUB_CA_CERT=
> credhub login

Add to .bashrc or make a targeting script that you source to define the concourse specific credhub target
> export CONCOURSE_CREDHUB_SERVER=”https://credhub.$ROOT_DOMAIN}:8844”
> export CONCOURSE_CREDHUB_CLIENT=”credhub_admin_client”
> SECRET_PATH=$(credhub find --name-like credhub_admin_client_credentials | grep name | awk ‘{print $NF}’)
> export CONCOURSE_CREDHUB_SECRET=$(credhub get --name $SECRET_PATH | grep password | awk '{print $NF}')
> CA_ID="$(om certificate-authorities --format json | jq -r '.[0].guid')"
> export CONCOURSE_CREDHUB_CA_CERT="$(om certificate-authority --id "${CA_ID}" --format json | jq -r .cert_pem)"

Useful commands
> credhub api
> credhub get -n <name>
> credhub find <name>
> credhub set -name <name path> -type <type> -value <value>
	Credhub naming structure
	/bosh-<environment_name>/<deployment_name>/<variable_name>
> credhub import -f <file>.yml

...credential types
https://github.com/cloudfoundry-incubator/credhub/blob/master/docs/operator-quick-start.md

Set permissions from new uaac client
> credhub set-permission --actor uaa-client:${CLIENT_NAME} --path /concourse/<team>/* operations read, write

Generates SSL cert for PAS
> credhub generate --name /concourse/team/name \
		--type certificate \
		--common-name haas-${HAAS_NUM}.pez.pivotal.io \
		--organization Pivotal \
		--organization-unit Education/PCFS \
		--state IL \
		--country US \
		--ca /concourse/team/name \
		--alternative-name *.sandbox.haas-${HAAS_NUM}.pez.pivotal.io\
--alternative-name *.sys.sandbox.haas-${HAAS_NUM}.pez.pivotal.io\
--alternative-name *.login.sys.sandbox.haas-${HAAS_NUM}.pez.pivotal.io\
--alternative-name *.uaa.sys.sandbox.haas-${HAAS_NUM}.pez.pivotal.io\
--alternative-name *.apps.sandbox.haas-${HAAS_NUM}.pez.pivotal.io

*Can target bosh credhub or concourse credhub
	Concourse credhub is what has all of your secrets for pas
	Bosh credhub will contain UAA admin passwords and creds that show up in your tiles


--------------------------------------------------------------------------------------------------------------------------------
FLY CLI --------------------------------------------------------------------------------------------------------------------------------
Create a new team
Log into main, set team (creates new team), then log into whichever group should use that team
> fly -t main login -c https://plane.controlplane.haas-420.pez.pivotal.io -k -n main
> fly -t main set-team -n sandbox --oauth-user admin
> fly -t main login -c https://plane.controlplane.haas-420.pez.pivotal.io -k -n sandbox

Useful Commands
> fly -t <team> sp -p <pipeline> -c <config.yml>
> fly -t <team> up -p <pipeline>
> fly -t <team> tj -j <pipeline>/<job>


--------------------------------------------------------------------------------------------------------------------------------
MC CLI (MINIO)
--------------------------------------------------------------------------------------------------------------------------------
How to target
> mc config host list
> mc --insecure config host add minio http://minio.controlplane.haas-${HAAS_NUM}.pez.pivotal.io:9000 ${MNIO_ACCESS_KEY} ${MINIO_SECRET_KEY}

Create bucket
> mc --insecure mb minio/${BUCKET_NAME}
List contents of bucket
> mc --insecure lb minio/${BUCKET_NAME}
Copy artifact into bucket
> mc --insecure cp ${ARTIFACT_PATH} minio/${BUCKET_NAME}
> mc cp --recursive ${ARTIFACT_PATH} minio/${BUCKET_NAME}

--------------------------------------------------------------------------------------------------------------------------------
SSH
--------------------------------------------------------------------------------------------------------------------------------
Passwordless login to jumpbox
> ssh-keygen
> ssh-copy-id -i ~/my-keys/my-ssh-key.pub ubuntu@${PUBLIC_IP}
> ssh -i ~/my-keys/my-ssh-key ubuntu@${PUBLIC_IP}

Access Jumpbox
> ssh ubuntu@${PUBLIC_IP}

Github SSH
> ssh-keygen -t rsa -b 4096 -C <email>
> eval "$(ssh-agent -s)"
> ssh-add -K ~/.ssh/id_rsa
> pbcopy < ~/.ssh/id_rsa.pub
Then go into github and add to your keys (doesn’t have to be id_rsa.pub...can make other, just be sure that you do the eval ssh-agent and ssh-add the key in your bash profile so it works every new instance)

To get into opmsan
ssh -i om_sb_key.pem ubuntu@10.197.30.16
vim /var/log/opsmanager/production.log

--------------------------------------------------------------------------------------------------------------------------------
p-automator
--------------------------------------------------------------------------------------------------------------------------------
> create-vm				create opsman vm
> configure-authentication		configure who can run ops
> configure-saml-authentication
> configure-director			configure bosh director
> upload-and-stage-product		add products
> configure-product
> apply-changes
> export installation
> upgrade-opsman

Set up OM VM from docker
> docker import ~/Downloads/platform-automation-image-*.tgz cloudfoundry/platform-automation:3.0.1

> docker run -it \
  -v ${TEMP_DIR}:/tmp/p_automator_config \
  cloudfoundry/platform-automation:3.0.1 \
  /bin/bash

> p-automator delete-vm --config "/tmp/p_automator_config/p_automator_config.yml"  --state-file "/tmp/p_automator_config/state.yml"
> p-automator create-vm \
  --config "/tmp/p_automator_config/p_automator_config.yml" \
  --image-file /tmp/p_automator_config/*.ova \
  --state-file "/tmp/p_automator_config/state.yml"



--------------------------------------------------------------------------------------------------------------------------------
MISC
--------------------------------------------------------------------------------------------------------------------------------
> df -h				disk usage
> wget https://localhost	test http
> grep --after-context <#> “<value>”		will give you the lines after
> grep --before-context <#> “<value>”	will give you the lines before
> tar xvzf <file>.tar.gz
> sed -e "s/.\{60\}/&\n/g"
> sudo chmod +x <file>

Get NSX-T Manager CA-Cert
> openssl s_client -showcerts -connect nsxmgr-01.haas-${HAAS_NUM}.pez.pivotal.io:443

VIM
u - undo
dd - delete line (cut)
ctrl r - redo
press v and move cursor to select block
    type d to cut block
    type p to paste block
<
> indent
:m to move line
    :m 12 - after 12th line
    :m 0 before first line
    :m $ after last line
    :5,7m 12 - move lines 5 through 7 after 12th line
$ - end of line
0 - beginning of line

TMUX
> ctrl + b + ;				toggle last active pane
   + up/down/either side	switch pane in direction
   + &				close current window
   + %				split vertically
   + “				split horizontally
> tmux kill-session
> tmux					starts session

--------------------------------------------------------------------------------------------------------------------------------
ACCESSING TILES AND SITES
--------------------------------------------------------------------------------------------------------------------------------
Access PEZ DNS via https://sc2-plesk-01.core.pez.pivotal.io:8443/
Self service DNS, only on the Pivotal Internal Network
Login -> username: haas-${HAAS_NUM}-user password: main PEZ password

Access minio via http://minio.controlplane.haas-${HAAS_NUM}.pez.pivotal.io:9000
The access key can be found in minio tile -> settings -> configure credentials
The secret key can be found in minio tile -> credentials -> secretkey

Access concourse via https://plane.controlplane.haas-${HAAS_NUM}.pez.pivotal.io
For credentials go to control plane tile -> credentials -> Uaa Users Admin Credentials
Can hook up fly cli to the concourse:
> fly login -t main -c https://plane.controlplane.haas-420.pez.pivotal.io/ -k
Copy the following link and grab the token from the url, paste as “Bearer <token>”
If u have issues, might need to change the version of the fly cli to match that of the target, or put https on the front of the url

Access ops manager via https://ops-manager.sandbox.haas-${HAAS_NUM}.pez.pivotal.io/
Login -> admin and PEZ password

Access apps manager (PAS) via https://apps.sys.sandbox.haas-${HAAS_NUM}.pez.pivotal.io/
Login with credentials from PAS tile -> Credentials -> UAA -> Admin Credentials

Access health watch tile via https://healthwatch.sys.${SYSTEMS_DOMAIN}
https://docs.pivotal.io/pcf-healthwatch/1-6/using.html
Login is actually from pas tile credentials (uaa -> admin)

Access reliability view tile via
https://docs.pivotal.io/reliability-view/v0.3/index.html
Login -> credentials under UI login
URL -> external_ip:port ie. http://34.67.240.176:3000
….


Google network name is network/subnet/region

If you are having an issue with accessing the webpage, there may be a step that needs to be taken to expose some of the networking. You can figure out the vm that is hosting the reliability view by going to the status tab of the reliability view tile and finding the CID VM.
Then go to GCP and configure some of the firewall settings. In this case, I took the ui label. Then went to firewall rules for vpc and selected “create firewall rule.” Name is ui, target tag is ui, source IP range is 0.0.0.0/0, tcp is 3000. Now the url should work and you will hit grafana.

Seems like reliability exporter is needed as well
