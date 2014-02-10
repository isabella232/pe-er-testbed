class testbed(
  $users = {},
) {
  validate_hash($users)

  $users_defaults = { 'managehome' => true, shell => '/bin/bash', }
  create_resources('user', $users, $users_defaults)

  ###############################################################################
  ## These must be specified in Hiera
  ###############################################################################
  # Why in the hell is the hiera() call necessary to put these in scope!!?!?
  #$github_deploy_pub_key = hiera('github_deploy_pub_key')
  #$github_deploy_priv_key = hiera('github_deploy_priv_key')
  #validate_string($github_deploy_pub_key)
  #validate_string($github_deploy_priv_key)


  ###############################################################################
  ## Let's set up a deploy key to GitHub so we can pull down a private repo
  ###############################################################################
  File { owner => 'root', group => 'root', mode => '0644', }

  file { '/root/.ssh': ensure => directory, mode => '0700', }

  file { '/root/.ssh/github_deploy_rsa':
    ensure => file,
    mode => '0600',
    content => $github_deploy_priv_key,
  }

  file { '/root/.ssh/github_deploy_rsa.pub':
    ensure => file,
    content => $github_deploy_pub_key,
  }

  file { '/root/.ssh/config':
    ensure => file,
    mode => '0600',
    source => "puppet:///${module_name}/root-.ssh-config',
  }

  ###############################################################################
  ## Setup the Puppet modules we will be using for cloud harness
  ###############################################################################
  package { 'librarian-puppet': ensure => present, provider => pe_gem, }

  file { '/etc/puppetlabs/puppet/Puppetfile': ensure => present, source => '/vagrant/puppet/Puppetfile', }

  exec { 'install Puppet modules to cloud harness':
    environment => 'HOME=/tmp',
    cwd => '/etc/puppetlabs/puppet',
  #  command => '/opt/puppet/bin/librarian-puppet install --verbose --destructive --clean 2>&1| /usr/bin/logger',
    command => '/opt/puppet/bin/librarian-puppet install --verbose | /usr/bin/logger',
    require => [File['/etc/puppetlabs/puppet/Puppetfile'],Package['librarian-puppet']],
  }
}
