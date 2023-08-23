#
# @summary
#   This class enables or disables auth
#
# @api private
#
class etcd::auth {
  assert_private()

  # Etcd_role {
  #   before => Exec['etcd::auth'],
  # }

  create_resources('etcd_role', $etcd::roles)

  $env_list = $etcd::etcdctl_env.map |$key, $value| { "${key}='${value}'" }
  $env = join($env_list, ' ')
  $etcdctl = "env ${env} etcdctl"
  $auth_disabled = "${etcdctl} auth status | grep 'Authentication Status: false'"

  notify { $auth_disabled: }

  if $etcd::auth {
    exec { 'etcd::auth::enable':
      path    => $facts['path'],
      command => "${etcdctl} auth enable",
      onlyif  => $auth_disabled,
    }
  } else {
    exec { 'etcd::auth::disable':
      path    => $facts['path'],
      # command => "${etcdctl} auth disable",
      command => "${etcdctl} auth status; /bin/false",
      unless  => $auth_disabled,
    }
  }
}
