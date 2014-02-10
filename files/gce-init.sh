#!/bin/bash -x

PATH=$PATH:/opt/google-cloud-sdk/bin

#gcloud auth login

for i aio puppetdb mco; do
  gcloud config set project pe-er-$i && \
  puppet apply /etc/puppetlabs/puppet/environments/production/modules/testbed/tests/testbed-gce-$i.pp \
    --certname $i --debug
done
