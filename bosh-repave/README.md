The bosh-mgmt pipeline will regularly cleanup the bosh director and repave diego_cells.

This works off of the https://github.com/vmware-tanzu-labs/bosh-repave repo, and if you want to repave more than digeo_cells in the deployment, it is recommended to used their repo instead.