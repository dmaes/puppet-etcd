# ETCD puppet module

This puppet module manages [etcd](https://etcd.io).
It uses package-based install method.

## Usage

A simple include should cover most use-cases.

```puppet
include etcd
```

Alternatively, the etc class accepts following parameters:

```puppet
class {'etc':
  package_names     => ['etc'],
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
