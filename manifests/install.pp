#
# @summary
#   This class handles the etcd installation using the
#   operating system's package manager
#
# @api private
#
class etcd::install {
  assert_private()

  if length($etcd::package_names) > 0 {
    package { $etcd::package_names:
      ensure => present,
    }
  }
}
