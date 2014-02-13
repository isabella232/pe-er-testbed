class testbed::gce(

) {
  $instances_defaults = {
    'ensure' => 'present',
    'zone' => 'us-central1-a', 
    'network' => 'default',
    'image' => 'projects/centos-cloud/global/images/centos-6-v20131120',
    'puppet_manifest' => true,
    'manifest' => "package { 'curl': ensure => installed, }
exec { 'fetch ng installer':
  path => ['/bin','/sbin','/usr/bin','/usr/sbin'],
  cwd => '/tmp',
  command => 'curl -L http://git.io/89dLgA | bash',
  require => Package['curl'],
}"
#    'startupscript' => 'puppet-enterprise.sh',
#    'metadata' => {
#      'pe_role' => 'agent',
#      'pe_master' => 'puppet',
#      'pe_version' => '3.1.3'
#    }
  }

  $firewalls_defaults = { 'ensure' => 'present', 'network' => 'default', }
}
