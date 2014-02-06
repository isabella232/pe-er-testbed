class testbed::gce::aio(
  $instances = {},
  $firewalls = {}
) {
  validate_hash($instances)
  validate_hash($firewalls)

  require ::testbed::gce

  $instances_defaults = {
    'ensure' => 'present',
    'zone' => 'us-central1-a', 
    'network' => 'default',
    'image' => 'projects/centos-cloud/global/images/centos-6-v20131120',
  }
  create_resources('gce_instance', $instances, $instances_defaults)

  $firewalls_defaults = {
    'ensure' => 'present',
    'network' => 'default',
  }
  create_resources('gce_firewall', $firewalls, $firewalls_defaults)
}
