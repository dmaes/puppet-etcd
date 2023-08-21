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

  file { '/etc/puppetlabs/puppet/etcdctl.yaml':
    ensure  => file,
    mode    => '0640',
    owner   => 'root',
    content => stdlib::to_yaml({ env => $etcd::etcdctl_env }),
  }

  if $etcd::manage_etcdctl_profile {
    file { '/etc/profile.d/etcdctl.sh':
      ensure  => file,
      mode    => '0640',
      owner   => 'root',
      content => epp("${module_name}/etcdctl.env.epp", {
          env => $etcd::etcdctl_env,
      }),
    }
  }
}
