class testbed::harness::aws (
  $projects = {},
  $aws_access_key_id,
  $aws_secret_access_key,
  $aws_ssh_pub_key,
  $aws_ssh_priv_key
) inherits testbed::aws {

  validate_hash($projects)
  validate_string($aws_access_key_id)
  validate_string($aws_secret_access_key)
  validate_string($aws_ssh_pub_key)
  validate_string($aws_ssh_priv_key)

  require java

  file { '/etc/puppetlabs/puppet/nodes/aws': ensure => directory, }

  File { owner => 'root', group => 'root', mode => '06', ensure => file, }

  file { 'root fog config':
    path => '/root/.fog',
    mode => '0600',
    content => template("${module_name}/aws/harness/fog.erb"),   
  }

  package { ['ec2-ami-tools', 'ec2-api-tools']: ensure => installed, }
}
