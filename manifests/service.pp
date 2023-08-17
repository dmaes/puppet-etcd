#
# @summary
#   This class manages the etcd systemd service
#
# @api private
#
class etcd::service {
  assert_private()

  if $etcd::manage_service {
    service { $etcd::service_name:
      ensure => 'running',
      enable => 'true',
    }
  }
}
