class testbed::gce::puppetdb(
  $instances = {},
) {
  validate_hash($instances)

  require ::testbed::gce

  $instances_defaults = {
    'ensure' => 'present',
    'zone' => 'us-central1-a', 
    'network' => 'default',
    'image' => 'projects/centos-cloud/global/images/centos-6-v20131120',
  }
  create_resources('gce_instance', $instances, $instances_defaults)
}
