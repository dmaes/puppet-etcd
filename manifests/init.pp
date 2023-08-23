# @summary
#   This module manages etcd (https://etcd.io)
#   It uses a package-based install,
#   and does not download binaries from a release page.
#
# @param package_names
#   A list of packages to install.
#   Empty list will not install any packages.
#   Default: ['etcd']
#
# @param config
#   Either a hash or a string containing etcd's config.
#   Hash will be converted to yaml,
#   string will be expected to already be in yaml format and will be used as-is.
#   Default: {name: $facts['networking']['fqdn'], data-dir: '/var/lib/etcd'}
#
# @param config_dir
#   Unixpath to the configuration directory
#   Default: '/etc/etcd'
#
# @param config_file
#   Filename of the configfile. Will be combined with $config_dir
#   Default: 'config.yaml'
#
# @param manage_config_dir
#   Wether to manage the config directory or not.
#   Default: false if $config_dir is '/etc' else true
#
# @param purge_config_dir
#   Wether to purge the config directory or not.
#   Default: same as $manage_config_dir
#
# @param manage_service
#   Wether to manage (run and enable) the service or not.
#   Default: true
#
# @param service_name
#   The name of the service
#   Default: 'etcd'
#
# @param etcdctl_env
#   Environment variables to use for etcdctl
#   Also used for the custom providers
#   Default: {}
#
#   Example for etcd with auth and TLS enabled:
#   ```
#   {
#     'ETCDCTL_INSECURE_TRANSPORT': 'false',
#     'ETCDCTL_USER': 'root',
#     'ETCDCTL_PASSWORD': 'Root123!',
#   }
#   ```
#
# @param manage_etcdctl_profile
#   Wether to manage /etc/profile.d/etcdctl.sh,
#   containing the env vars from $etcdctl_env.
#   Default: true
#
# @param auth
#   Enable/disable auth.
#   Must add credentials to $etcdctl_env when enabled, to keep using types/providers.
#   Default: false
#
# @param roles
#   `etcd_role` resources to create.
#   Default: {}
#
# @param purge_roles
#   Wether to purge unmanaged roles or not
#   Default: true
#
# @param role_permissions
#   `etcd_role_permission` resources to create.
#   Default: {}
#
# @param purge_role_permissions
#   Wether to purge unmanaged role permissions or not
#   Default: true
#
# @param users
#   `etcd_user` resources to create.
#   Default: {}
#
# @param purge_users
#   Wether to purge unmanaged users or not
#   Default: true
#
class etcd (
  Array[String]         $package_names          = ['etcd'],
  Variant[Hash, String] $config                 = {
    'name'     => $facts['networking']['fqdn'],
    'data-dir' => '/var/lib/etcd',
  }, # Set empty to not manage config
  Stdlib::Unixpath      $config_dir             = '/etc/etcd',
  String                $config_file            = 'config.yaml',
  Boolean               $manage_config_dir      = ($config_dir != '/etc'),
  Boolean               $purge_config_dir       = $manage_config_dir,
  Boolean               $manage_service         = true,
  String                $service_name           = 'etcd',
  Hash[String, String]  $etcdctl_env            = {},
  Boolean               $manage_etcdctl_profile = true,
  Boolean               $auth                   = false,
  Hash[String, Hash]    $roles                  = {},
  Boolean               $purge_roles            = true,
  Hash[String, Hash]    $role_permissions       = {},
  Boolean               $purge_role_permissions = true,
  Hash[String, Hash]    $users                  = {},
  Boolean               $purge_users            = true,
) {
  contain etcd::install
  contain etcd::config
  contain etcd::service
  contain etcd::auth

  Class['etcd::install']
  -> Class['etcd::config']
  -> Class['etcd::service']
  -> Class['etcd::auth']
}
