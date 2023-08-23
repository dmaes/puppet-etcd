#
# @summary
#   This class manages auth-related stuff
#
# @api private
#
class etcd::auth {
  assert_private()

  Etcd_role {
    before => Exec['etcd::auth'],
  }

  Etcd_role_permission {
    before => Exec['etcd::auth'],
  }

  Etcd_user {
    before => Exec['etcd::auth'],
  }

  create_resources('etcd_role', $etcd::roles)
  create_resources('etcd_role_permission', $etcd::role_permissions)
  create_resources('etcd_user', $etcd::users)

  if $etcd::purge_roles {
    resources { 'etcd_role':
      purge => true,
    }
  }

  if $etcd::purge_role_permissions {
    resources { 'etcd_role_permission':
      purge => true,
    }
  }

  if $etcd::purge_users {
    resources { 'etcd_user':
      purge => true,
    }
  }

  $env_list = $etcd::etcdctl_env.map |$key, $value| { "${key}='${value}'" }
  $env = join($env_list, ' ')
  $etcdctl = "env ${env} ETCDCTL_WRITE_OUT='simple' etcdctl"
  $auth_disabled = "${etcdctl} auth status | grep 'Authentication Status: false'"

  if $etcd::auth {
    exec { 'etcd::auth':
      path    => $facts['path'],
      command => "${etcdctl} auth enable",
      onlyif  => $auth_disabled,
    }
  } else {
    exec { 'etcd::auth':
      path    => $facts['path'],
      command => "${etcdctl} auth disable",
      unless  => $auth_disabled,
    }
  }
}
