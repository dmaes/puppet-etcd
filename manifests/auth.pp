#
# @summary
#   This class enables or disables auth
#
# @api private
#
class etcd::auth {
  ensure_private()

  Etcd_role {
    before => Exec['etcd::auth'],
  }

  create_roles('etcd_role', $etcd::roles)

  $auth_disabled = "etcdctl auth status | grep 'Authentication Status: false'"
  $env = $etcd::etcdctl_env.map |$key, $value| { "${key}='${value}'" }

  if $etcd::auth {
    exec { 'etcd::auth':
      path        => $facts['path'],
      environment => $env,
      command     => 'etcdctl auth enable',
      onlyif      => $auth_disabled,
    }
  } else {
    exec { 'etcd::auth':
      path        => $facts['path'],
      environment => $env,
      command     => 'etcdctl auth disable',
      unless      => $auth_disabled,
    }
  }
}
