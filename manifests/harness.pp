class testbed::harness(
  $github_envrepo_deploy_pub_key,
  $github_envrepo_deploy_priv_key,
  $autosign = false,
) inherits testbed {

  validate_string($github_envrepo_deploy_pub_key)
  validate_string($github_envrepo_deploy_priv_key)
  validate_bool($autosign)

  ###############################################################################
  ## Let's set up a deploy key to GitHub so we can pull down a private repo
  ###############################################################################
  File { owner => 'root', group => 'root', mode => '0644', }

  file { '/root/.ssh': ensure => directory, mode => '0700', }

  file { '/root/.ssh/github_envrepo_deploy_rsa':
    ensure => file,
    mode => '0600',
    content => $github_envrepo_deploy_priv_key,
  }

  file { '/root/.ssh/github_envrepo_deploy_rsa.pub':
    ensure => file,
    mode => '0600',
    content => $github_envrepo_deploy_pub_key,
  }

  file { '/root/.ssh/config':
    ensure => file,
    mode => '0600',
    source => "puppet:///modules/${module_name}/root-.ssh-config",
  }

  ###############################################################################
  ## Setup r10k
  ###############################################################################
  package { 'librarian-puppet': ensure => present, provider => pe_gem, }

  require r10k
#  include r10k::mcollective
#  include r10k::prerun_command

  file { 'Puppet production env dir':
    ensure => directory,
    path => '/etc/puppetlabs/puppet/environments',
  }
  
  Ini_setting { path => '/etc/puppetlabs/puppet/puppet.conf', ensure => present, section => 'main', }

  ini_setting { 'set puppet modulepath':
    setting => 'modulepath',
    value => '/etc/puppetlabs/puppet/environments/$environment/modules:/opt/puppet/share/puppet/modules',
  }

  ini_setting { 'set puppet path to site.pp':
    setting => 'manifest',
    value => '/etc/puppetlabs/puppet/environments/$environment/manifests/site.pp',
  }

  ini_setting { 'set puppet path to hiera config':
    setting => 'hiera_config',
    value => '/etc/puppetlabs/puppet/hiera.yaml',
  }

  file { 'hiera config':
    ensure => file,
    path => '/etc/puppetlabs/puppet/hiera.yaml',
    source => "puppet:///modules/${module_name}/hiera.yaml",
    notify => Service['pe-httpd'],
  }

  file { 'autosign.conf':
    ensure => file,
    
  }

  file { 'autosign.conf':
    ensure => file,
    content => $autosign ? {
      true => "*.${::domain}",
      default => '',
    }
  }
}
