class testbed::aws::harness (
) inherits testbed::aws {
  file { '/etc/puppetlabs/puppet/nodes/aws': ensure => directory, }
}
