class testbed::gce::harness(
  $projects = {}
) inherits testbed::gce {
  validate_hash($projects)

  require ::testbed

  File { owner => 'root', group => 'root', mode => '0644', ensure => file, }

  file { '/etc/puppetlabs/puppet/device.conf':
    content => template("${module_name}/gce/device.conf.erb"),
  }

  file { '/etc/puppetlabs/puppet/nodes/gce': ensure => directory }
  
  file { '/etc/puppetlabs/puppet/nodes/gce/gce-init.sh':
    mode => '0755',
    source => "puppet:///modules/${module_name}/gce-init.sh",
  }
}
