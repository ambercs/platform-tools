The bosh-mgmt pipeline will regularly cleanup the bosh director and repave diego_cells.

If you want to repave more than digeo_cells in the deployment, it is recommended to used the https://github.com/vmware-tanzu-labs/bosh-repave instead.

If using k8s concourse, set the secrets for this pipeline with the following command:

$ kub create secret generic opsman \
    --from-literal=url=[OM-URL] \
    --from-literal=username=[OM-USERNAME] \
    --from-literal=password=[OM-PASSWORD] \
    --from-literal=skip-ssl-validation=true \
    --from-file=[PRIVATE-KEY-FILE] \
    -n concourse-main