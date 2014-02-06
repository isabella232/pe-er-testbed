class testbed::gce(
  $projects = {}
) {
  validate_hash($projects)

  require testbed

  file { '/etc/puppetlabs/puppet/device.conf':
    ensure => file,
    content => template("${module_name}/gce/device.conf.erb"),
  }
}
