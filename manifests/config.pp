#
# @summary
#   This class handles the etcd configuration file
#
# @api private
#
class etcd::config {
  assert_private()

  File {
    owner => 'etcd',
  }

  if $etcd::manage_config_dir {
    file { $etcd::config_dir:
      ensure  => directory,
      purge   => $etcd::purge_config_dir,
      recurse => true,
    }
  }

  if !empty($etcd::config) {
    file { "${etcd::config_dir}/${etcd::config_file}":
      ensure  => file,
      content => $etcd::config ? { # lint:ignore:selector_inside_resource
        Hash   => stdlib::to_yaml($etcd::config),
        String => $etcd::config,
      },
      notify  => Class['etcd::service'],
    }
  }
}
