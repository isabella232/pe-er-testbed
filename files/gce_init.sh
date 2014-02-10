#!/bin/bash -x

PATH=$PATH:/opt/google-cloud-sdk/bin

gcloud auth login

for i pe-er-aio pe-er-puppetdb pe-er-mco; do
  puppet apply /opt/puppetlabs/puppet/environments/production/modules/testbed/tests/$i.pp \
    --certname $i
done
