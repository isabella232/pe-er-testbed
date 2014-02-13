class testbed::gce(

) {
  $instances_defaults = {
    'ensure' => 'present',
    'zone' => 'us-central1-a', 
    'network' => 'default',
    'image' => 'projects/centos-cloud/global/images/centos-6-v20131120',
    'startupscript' => 'puppet-enterprise.sh',
    'metadata' => {
      'pe_role' => 'agent',
      'pe_master' => 'puppet',
      'pe_version' => '3.1.3'
    },
    'manifest' => "host { ${puppetmaster_fqdn}:
        ensure => present,
        ip => ${puppmaster_ip},
        aliases => 'puppet',
        }"
    }
  create_resources('gce_instance', $instances, $instances_defaults)

  $firewalls_defaults = { 'ensure' => 'present', 'network' => 'default', }
  create_resources('gce_firewall', $firewalls, $firewalls_defaults)
}
