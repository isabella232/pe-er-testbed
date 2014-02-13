class testbed(
  $users = {},
  $sh_authorized_keys = {}
) {

  validate_hash($users)
  validate_hash($ssh_authorized_keys)

  $users_defaults = { managehome => true, }
  create_resources('pe_accounts::user', $users, $users_defaults)
  
  $sshauthkeys_defaults = {}
  create_resources('ssh_authorized_keys', $ssh_authorized_keys, $sshauthkeys_defaults)
}
