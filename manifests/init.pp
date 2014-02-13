class testbed(
  $users = {},
) {

  validate_hash($users)

  $users_default = { ensure => present, managehome => true, }
  create_resources('pe_accounts::user', $users, $users_defaults)
}
