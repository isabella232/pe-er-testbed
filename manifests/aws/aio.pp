class testbed::aws::aio(
  $instances = {}
) inherts testbed::aws {
  
  validate_hash($instances)
  create_resources('instance', $instances, $instances_defaults)
}
