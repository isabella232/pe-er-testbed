class testbed::gce::puppetmaster(
  $instances = {},
  $firewalls = {},
) inherits testbed::gce {
  validate_hash($instances)
  validate_hash($firewalls)

  create_resources('gce_instance', $instances, $instances_defaults)
  create_resources('gce_firewall', $firewalls, $firewalls_defaults)
}
