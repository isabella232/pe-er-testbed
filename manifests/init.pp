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
    source => "puppet:///modules/${module_name}/root-.ssh-config",
  }

  ###############################################################################
  ## Setup the Puppet environment on the harness and nodes to support environment
  ###############################################################################
  package { 'librarian-puppet': ensure => present, provider => pe_gem, }

  file { 'Puppet production env dir':
    ensure => directory,
    path => '/etc/puppetlabs/puppet/environments',
  }
  
  vcsrepo { 'Puppet data for setting up the testbed Puppet environment':
    ensure => latest,
    provider => 'git',
    path => '/etc/puppetlabs/puppet/environments/production',
    force => true,
    source => 'git@github.com:puppetlabs/pe-er-testbed-env',
    require => File['Puppet production env dir'],
  }

  exec { 'install Puppet modules to cloud harness':
    environment => 'HOME=/tmp',
    cwd => '/etc/puppetlabs/puppet/environments/production',
  #  command => '/opt/puppet/bin/librarian-puppet install --verbose --destructive --clean 2>&1| /usr/bin/logger',
    command => '/opt/puppet/bin/librarian-puppet install --verbose | /usr/bin/logger',
    require => [
      Package['librarian-puppet'],
      Vcsrepo['Puppet data for setting up the testbed Puppet environment'],
    ],
  }
}
