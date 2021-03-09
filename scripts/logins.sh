#!/bin/bash
pivnet login --api-token=[API-TOKEN]

export OM_USERNAME=[ADMIN]
export OM_PASSWORD=[PASSWORD]
export OM_TARGET=[https://ops-manager...]
export OM_SKIP_SSL_VALIDATION=true

eval “$(om bosh-env)”
