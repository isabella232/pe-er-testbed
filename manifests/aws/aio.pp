class testbed::aws::aio(
  $aws_access_key_id,
  $aws_secret_access_key,
  $region = 'us-west-1',
  $instances = {}
) {
  
  validate_string($aws_access_key_id)
  validate_string($aws_secret_access_key_id)
  validate_string($region)
  validate_hash($instances)

  cloud_connection { 'aws':
    user => $aws_access_key_id,
    pass => $aws_secret_access_key,
    location => $region,
  }

  $instances_defaults = { 
    ensure => present, 
    provider => 'ec2',
    connection => 'aws',
    image => 'ami-5d456c18',
    flavor => 't1.micro',
    require => Cloud_connection['aws'],
  }
  create_resources('instance', $instances, $instances_defaults)
}
