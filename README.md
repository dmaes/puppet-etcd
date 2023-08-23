# ETCD puppet module

This puppet module manages [etcd](https://etcd.io).
It currently uses the operating system's package manager to install the required software.
Repo management is not supported.
Only tested on etcd v3 api.

## Usage

A simple include should cover most use-cases.

```puppet
include etcd
```

Alternatively, the etcd class accepts following parameters:

```puppet
class {'etcd':
  package_names     => ['etcd'],
  config            =>  {
    'name'     => $facts['networking']['fqdn'],
    'data-dir' => '/var/lib/etcd',
  }, # Set empty to not manage config
  config_dir        => '/etc/etcd',
  config_file       => 'config.yaml',
  manage_config_dir => true,
  purge_config_dir  => true,
  manage_service    => true,
  service_name      => 'etcd',
}
```

See [REFERENCE.md](./REFERENCE.md) for more information. These params can of course also be overwritten using Hiera.

## License

[Apache 2.0](./LICENSE)
