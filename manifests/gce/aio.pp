class testbed::gce::aio(
  $instances = {},
  $firewalls = {},
  $puppetmaster_fqdn,
  $puppetmaster_ip
) inherits testbed::gce {
  validate_hash($instances)
  validate_hash($firewalls)
  validate_string($puppetmaster_fqdn)
  validate_string($puppetmaster_ip)

  create_resources('gce_instance', $instances, $instances_defaults)
  create_resources('gce_firewall', $firewalls, $firewalls_defaults)
}
