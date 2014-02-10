class testbed::gce::harness(
  $projects = {}
) inherits testbed::gce {
  validate_hash($projects)

  require ::testbed

  file { '/etc/puppetlabs/puppet/device.conf':
    ensure => file,
    content => template("${module_name}/gce/device.conf.erb"),
  }

  file { '/etc/puppetlabs/puppet/nodes/gce': ensure => directory }
}
