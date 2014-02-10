class testbed::aws::aio(
  $instances = {},
) inherits testbed::aws {
 
  $instances_defaults = {} 
  create_resources('testbed::aws::instance', $instances, $instances_defaults)
}
