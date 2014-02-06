class testbed::gce::aio(
  $instances = {},
) {
  validate_hash($instances)

  require testbed::gce

  $instances_defaults = { 
    'zone' => 'us-central-1a', 
    'network' => 'default',
    'image' => 'projects/centos-cloud/global/images/centos-6-v20131120',
  }

  create_resources('gce_instance', $instances, $instances_defaults)
}
