class testbed::gce(
  $projects = {}
) {
  validate_hash($projects)

  require testbed

  file { '/etc/puppetlabs/puppet/devices.conf':
    ensure => file,
    content => template("${module_name}/gce/devices.conf.erb"),
  }
}
