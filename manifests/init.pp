class testbed(
  $users = {}
) {
  validate_hash($users)

  $users_defaults = { 'managehome' => true, shell => '/bin/bash', }
  create_resources('user', $users, $users_defaults)
}
