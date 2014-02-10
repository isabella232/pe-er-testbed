define testbed::aws::instance(
  $ensure = 'present',
  $subnet,
  $type = 'm1.small',
  $image = 'ami-b9341afc',
  $region = 'us-west-1',
  $keyname,
) {

  validate_re($ensure, '^(present|absent)$')
  validate_string($subnet)
  validate_string($type)
  validate_string($image)
  validate_string($region)
  validate_string($keyname)

  Exec { path => ['/bin', '/usr/bin', '/usr/bin', '/usr/bin', '/opt/puppet/bin'], }

  case $ensure {

    'present': {
      exec { "instantiate AWS ${name}...":
        command => "puppet node_aws create --debug --image=${image} --subnet=${subnet} --type=${type} --region=${region} --keyname=${keyname}",
      }
    }

    'absent': {
      exec { "terminate AWS ${name}...":
        command => "puppet node_aws terminate --debug --region=${region} --keyname=${keyname} ${name}",
      }
    }

  }

}
