#!/bin/bash

echo "Log in to pivnet and om clis first"

echo "download products from pivnet"
pivnet download-product-files --product-slug='p-healthwatch' --release-version='2.1.0' --product-file-id=909864
pivnet download-product-files --product-slug='p-healthwatch' --release-version='2.1.0' --product-file-id=909859
pivnet download-product-files --product-slug='stemcells-ubuntu-xenial' --release-version='621.117' --product-file-id=914472

echo "upload OM products"
om upload-product -p healthwatch-pas-exporter-2.1.0-build.43.pivotal
om upload-product -p healthwatch-2.1.0-build.43.pivotal
om upload-stemcell -s bosh-stemcell-621.117-vsphere-esxi-ubuntu-xenial-go_agent.tgz