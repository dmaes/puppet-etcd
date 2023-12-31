# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

#### Public Classes

* [`etcd`](#etcd): This module manages etcd (https://etcd.io)
It uses a package-based install,
and does not download binaries from a release page.

#### Private Classes

* `etcd::auth`: This class manages auth-related stuff
* `etcd::config`: This class handles the etcd configuration file
* `etcd::install`: This class handles the etcd installation using the
operating system's package manager
* `etcd::service`: This class manages the etcd systemd service
* `etcd::snapshot`: This class manages a systemd timer to create snapshots

### Resource types

* [`etcd_role`](#etcd_role): @summary Manage an etcd role
* [`etcd_role_permission`](#etcd_role_permission): @summary Manage an etcd role permissions
* [`etcd_user`](#etcd_user): @summary Manage etcd users. This resource does not manage user passwords, since etcd doesn't provide the necessary endpoints to do this clean

### Functions

* [`etcd::prefix_range_end`](#etcd--prefix_range_end): Calculates the range-end for a given prefix.
Can be used for the `range_end` parameter of `etcd_role_permission`, to grant prefix.

## Classes

### <a name="etcd"></a>`etcd`

This module manages etcd (https://etcd.io)
It uses a package-based install,
and does not download binaries from a release page.

#### Parameters

The following parameters are available in the `etcd` class:

* [`package_names`](#-etcd--package_names)
* [`config`](#-etcd--config)
* [`config_dir`](#-etcd--config_dir)
* [`config_file`](#-etcd--config_file)
* [`manage_config_dir`](#-etcd--manage_config_dir)
* [`purge_config_dir`](#-etcd--purge_config_dir)
* [`manage_service`](#-etcd--manage_service)
* [`service_name`](#-etcd--service_name)
* [`etcdctl_env`](#-etcd--etcdctl_env)
* [`manage_etcdctl_profile`](#-etcd--manage_etcdctl_profile)
* [`auth`](#-etcd--auth)
* [`roles`](#-etcd--roles)
* [`purge_roles`](#-etcd--purge_roles)
* [`role_permissions`](#-etcd--role_permissions)
* [`purge_role_permissions`](#-etcd--purge_role_permissions)
* [`users`](#-etcd--users)
* [`purge_users`](#-etcd--purge_users)
* [`snapshot`](#-etcd--snapshot)
* [`snapshot_path`](#-etcd--snapshot_path)
* [`snapshot_oncalendar`](#-etcd--snapshot_oncalendar)

##### <a name="-etcd--package_names"></a>`package_names`

Data type: `Array[String]`

A list of packages to install.
Empty list will not install any packages.
Default: ['etcd']

Default value: `['etcd']`

##### <a name="-etcd--config"></a>`config`

Data type: `Variant[Hash, String]`

Either a hash or a string containing etcd's config.
Hash will be converted to yaml,
string will be expected to already be in yaml format and will be used as-is.
Default: {name: $facts['networking']['fqdn'], data-dir: '/var/lib/etcd'}

Default value:

```puppet
{
    'name'     => $facts['networking']['fqdn'],
    'data-dir' => '/var/lib/etcd',
  }
```

##### <a name="-etcd--config_dir"></a>`config_dir`

Data type: `Stdlib::Unixpath`

Unixpath to the configuration directory
Default: '/etc/etcd'

Default value: `'/etc/etcd'`

##### <a name="-etcd--config_file"></a>`config_file`

Data type: `String`

Filename of the configfile. Will be combined with $config_dir
Default: 'config.yaml'

Default value: `'config.yaml'`

##### <a name="-etcd--manage_config_dir"></a>`manage_config_dir`

Data type: `Boolean`

Wether to manage the config directory or not.
Default: false if $config_dir is '/etc' else true

Default value: `($config_dir != '/etc'`

##### <a name="-etcd--purge_config_dir"></a>`purge_config_dir`

Data type: `Boolean`

Wether to purge the config directory or not.
Default: same as $manage_config_dir

Default value: `$manage_config_dir`

##### <a name="-etcd--manage_service"></a>`manage_service`

Data type: `Boolean`

Wether to manage (run and enable) the service or not.
Default: true

Default value: `true`

##### <a name="-etcd--service_name"></a>`service_name`

Data type: `String`

The name of the service
Default: 'etcd'

Default value: `'etcd'`

##### <a name="-etcd--etcdctl_env"></a>`etcdctl_env`

Data type: `Hash[String, String]`

Environment variables to use for etcdctl
Also used for the custom providers
Default: {}

Example for etcd with auth and TLS enabled:
```
{
  'ETCDCTL_INSECURE_TRANSPORT': 'false',
  'ETCDCTL_USER': 'root',
  'ETCDCTL_PASSWORD': 'Root123!',
}
```

Default value: `{}`

##### <a name="-etcd--manage_etcdctl_profile"></a>`manage_etcdctl_profile`

Data type: `Boolean`

Wether to manage /etc/profile.d/etcdctl.sh,
containing the env vars from $etcdctl_env.
Default: true

Default value: `true`

##### <a name="-etcd--auth"></a>`auth`

Data type: `Boolean`

Enable/disable auth.
Must add credentials to $etcdctl_env when enabled, to keep using types/providers.
Default: false

Default value: `false`

##### <a name="-etcd--roles"></a>`roles`

Data type: `Hash[String, Hash]`

`etcd_role` resources to create.
Default: {}

Default value: `{}`

##### <a name="-etcd--purge_roles"></a>`purge_roles`

Data type: `Boolean`

Wether to purge unmanaged roles or not
Default: true

Default value: `true`

##### <a name="-etcd--role_permissions"></a>`role_permissions`

Data type: `Hash[String, Hash]`

`etcd_role_permission` resources to create.
Default: {}

Default value: `{}`

##### <a name="-etcd--purge_role_permissions"></a>`purge_role_permissions`

Data type: `Boolean`

Wether to purge unmanaged role permissions or not
Default: true

Default value: `true`

##### <a name="-etcd--users"></a>`users`

Data type: `Hash[String, Hash]`

`etcd_user` resources to create.
Default: {}

Default value: `{}`

##### <a name="-etcd--purge_users"></a>`purge_users`

Data type: `Boolean`

Wether to purge unmanaged users or not
Default: true

Default value: `true`

##### <a name="-etcd--snapshot"></a>`snapshot`

Data type: `Boolean`

Add systemd timer to create snapshots in $snapshot_path
Default: false

Default value: `false`

##### <a name="-etcd--snapshot_path"></a>`snapshot_path`

Data type: `Stdlib::Unixpath`

The path to save snapshots to, if $snapshot is enabled
Default: /var/lib/etcd/snapshot.db

Default value: `'/var/lib/etcd/snapshot.db'`

##### <a name="-etcd--snapshot_oncalendar"></a>`snapshot_oncalendar`

Data type: `String`

The systemd OnCalendar timestamp to run snapshotting
Default: *-*-* 00:00:00

Default value: `'*-*-* 00:00:00'`

## Resource types

### <a name="etcd_role"></a>`etcd_role`

@summary
Manage an etcd role

#### Properties

The following properties are available in the `etcd_role` type.

##### `ensure`

Valid values: `present`, `absent`

The basic property that the resource should be in.

Default value: `present`

#### Parameters

The following parameters are available in the `etcd_role` type.

* [`name`](#-etcd_role--name)
* [`provider`](#-etcd_role--provider)

##### <a name="-etcd_role--name"></a>`name`

namevar

The name of the role.

##### <a name="-etcd_role--provider"></a>`provider`

The specific backend to use for this `etcd_role` resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

### <a name="etcd_role_permission"></a>`etcd_role_permission`

@summary
Manage an etcd role permissions

#### Properties

The following properties are available in the `etcd_role_permission` type.

##### `ensure`

Valid values: `present`, `absent`

The basic property that the resource should be in.

Default value: `present`

##### `key`

The key to grant permission on. (required)

##### `permission`

The permission type, must be one of `(read|write|readwrite)`.

##### `range_end`

Optional range end to grant permission on. Use `etcd::prefix_range_end($key)` if you want to grant prefix.

##### `role`

The name of the role to grant to. (required)

#### Parameters

The following parameters are available in the `etcd_role_permission` type.

* [`name`](#-etcd_role_permission--name)
* [`provider`](#-etcd_role_permission--provider)

##### <a name="-etcd_role_permission--name"></a>`name`

namevar

The name of the role permission. Must be of `${role}:${key}` format.

##### <a name="-etcd_role_permission--provider"></a>`provider`

The specific backend to use for this `etcd_role_permission` resource. You will seldom need to specify this --- Puppet
will usually discover the appropriate provider for your platform.

### <a name="etcd_user"></a>`etcd_user`

@summary
Manage etcd users.
This resource does not manage user passwords, since etcd doesn't provide the necessary endpoints to do this cleanly.
Users will be created without password (aka: only cert auth allowed), and manually configured passwords will be ignored.

#### Properties

The following properties are available in the `etcd_user` type.

##### `ensure`

Valid values: `present`, `absent`

The basic property that the resource should be in.

Default value: `present`

##### `roles`

The list of roles to grant to the users.

#### Parameters

The following parameters are available in the `etcd_user` type.

* [`name`](#-etcd_user--name)
* [`provider`](#-etcd_user--provider)

##### <a name="-etcd_user--name"></a>`name`

namevar

The name of the user.

##### <a name="-etcd_user--provider"></a>`provider`

The specific backend to use for this `etcd_user` resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

## Functions

### <a name="etcd--prefix_range_end"></a>`etcd::prefix_range_end`

Type: Ruby 4.x API

Calculates the range-end for a given prefix.
Can be used for the `range_end` parameter of `etcd_role_permission`, to grant prefix.

#### `etcd::prefix_range_end(String $prefix)`

The etcd::prefix_range_end function.

Returns: `Any` The range-end for the given prefix.

##### `prefix`

Data type: `String`

The prefix key to calculate the range-end for

