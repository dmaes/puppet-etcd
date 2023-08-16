#
class etcd::install {
  assert_private()

  if length($etcd::package_names) > 0 {
    package { $etcd::package_names:
      ensure => present,
    }
  }
}
