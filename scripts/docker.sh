#!/bin/bash
printf "Running example for pulling and running a docker image\n\n"
printf "Pull image\n"
docker pull pcfplatformrecovery/bbr-pcf-pipeline-tasks:final
printf "\n\nList images\n"
docker images
printf "\n\nRun command on image\n"
docker run -it --rm -v $PWD:/workspace -w /workspace pcfplatformrecovery/bbr-pcf-pipeline-tasks:final om -v
printf "\n\nAccess image\n"
docker run -it --rm -v $PWD:/workspace -w /workspace pcfplatformrecovery/bbr-pcf-pipeline-tasks:final
