Default concourse helm deployment.

Find chart and instructions here:

    https://github.com/concourse/concourse-chart

Install chart with:

    $ helm install concourse concourse/concourse

Upgrade the deployment with this command:

    $ helm upgrade concourse concourse/concourse -f concourse.yml