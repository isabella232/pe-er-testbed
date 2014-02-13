class testbed::harness(
  $users = {},
  $github_data_deploy_pub_key,
  $github_data_deploy_priv_key,
  $github_testbed_module_deploy_pub_key,
  $github_testbed_module_deploy_priv_key
) inherits testbed {

  validate_hash($users)

  $users_defaults = { 'managehome' => true, shell => '/bin/bash', }
  create_resources('user', $users, $users_defaults)

  validate_string($github_data_deploy_pub_key)
  validate_string($github_data_deploy_priv_key)
  validate_string($github_testbed_module_deploy_pub_key)
  validate_string($github_testbed_module_deploy_priv_key)

  ###############################################################################
  ## Let's set up a deploy key to GitHub so we can pull down a private repo
  ###############################################################################
  File { owner => 'root', group => 'root', mode => '0644', }

  file { '/root/.ssh': ensure => directory, mode => '0700', }

  file { '/root/.ssh/github_data_deploy_rsa':
    ensure => file,
    mode => '0600',
    content => $github_data_deploy_priv_key,
  }

  file { '/root/.ssh/github_data_deploy_rsa.pub':
    ensure => file,
    mode => '0600',
    content => $github_data_deploy_pub_key,
  }

  file { '/root/.ssh/github_testbed_module_deploy_rsa':
    ensure => file,
    mode => '0600',
    content => $github_testbed_module_deploy_priv_key,
  }

  file { '/root/.ssh/github_testbed_module_deploy_rsa.pub':
    ensure => file,
    mode => '0600',
    content => $github_testbed_module_deploy_pub_key,
  }

  file { '/root/.ssh/config':
    ensure => file,
    mode => '0600',
    source => "puppet:///modules/${module_name}/root-.ssh-config",
  }

  ###############################################################################
  ## Setup the Puppet 'chroot' (for harness and downstream nodes)
  ###############################################################################
  package { 'librarian-puppet': ensure => present, provider => pe_gem, }

  file { 'Puppet production env dir':
    ensure => directory,
    path => '/etc/puppetlabs/puppet/environments',
  }
  
  vcsrepo { 'Puppet data for setting up the testbed Puppet environment':
    ensure => latest,
    provider => 'git',
    revision => 'master',
    path => '/etc/puppetlabs/puppet/environments/production',
    force => true,
    source => 'git@github.com:puppetlabs/pe-er-testbed-env',
    require => [
      File['Puppet production env dir'],
      File['/root/.ssh/config'],
      File['/root/.ssh/github_data_deploy_rsa'],
    ],
  }

  exec { 'install Puppet modules to cloud harness':
    environment => 'HOME=/tmp',
    cwd => '/etc/puppetlabs/puppet/environments/production',
  #  command => '/opt/puppet/bin/librarian-puppet install --verbose --destructive --clean 2>&1| /usr/bin/logger',
    command => '/opt/puppet/bin/librarian-puppet install --verbose | /usr/bin/logger',
    require => [
      Package['librarian-puppet'],
      Vcsrepo['Puppet data for setting up the testbed Puppet environment'],
      File['/root/.ssh/github_testbed_module_deploy_rsa'],
    ],
  }

  Ini_setting { path => '/etc/puppetlabs/puppet/puppet.conf', ensure => present, section => 'main', }

  ini_setting { 'set puppet modulepath':
    setting => 'modulepath',
    value => '/etc/puppetlabs/puppet/environments/production/modules:/opt/puppet/share/puppet/modules',
  }

  ini_setting { 'set puppet path to site.pp':
    setting => 'manifest',
    value => '/etc/puppetlabs/puppet/environments/production/manifests/site.pp',
  }

  ini_setting { 'set puppet path to hiera config':
    setting => 'hiera_config',
    value => '/etc/puppetlabs/puppet/environments/production/data/hiera.yaml',
  }

  file { '/etc/puppetlabs/puppet/nodes': ensure => directory, }
}
