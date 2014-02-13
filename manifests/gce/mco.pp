class testbed::gce::mco(
  $instances = {},
  $firewalls = {},
  $puppetmaster_fqdn,
  $puppetmaster_ip
) inherits testbed::gce {
  validate_hash($instances)
  validate_hash($firewalls)
  validate_string($puppetmaster_fqdn)
  validate_string($puppetmaster_ip)
}
