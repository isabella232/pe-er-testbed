class testbed::gce::mco(
  $disks = {},
  $instances = {},
  $firewalls = {}
) inherits testbed::gce {
  validate_hash($disks)
  validate_hash($instances)
  validate_hash($firewalls)

  require ::testbed::gce

  $disks_defaults = { ensure => 'present', zone => 'us-central1-a', source_image => 'centos-6-v20131120', }
  create_resources('gce_disk', $disks, $disks_defaults)

  $instances_defaults = {
    'ensure' => 'present',
    'zone' => 'us-central1-a', 
    'network' => 'default',
    'image' => 'projects/centos-cloud/global/images/centos-6-v20131120',
  }
  create_resources('gce_instance', $instances, $instances_defaults)

  $firewalls_defaults = { 'ensure' => 'present', 'network' => 'default', }
  create_resources('gce_firewall', $firewalls, $firewalls_defaults)
}
