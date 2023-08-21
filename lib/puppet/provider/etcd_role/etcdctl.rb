# frozen_string_literal: true

require_relative('../etcdctl')

Puppet::Type.type(:etcd_role).provide(:etcdctl, parent: Puppet::Provider::Etcdctl) do
  desc 'Manages etcd roles'

  def self.instances
    instances = []
    etcdctl(['role', 'list'])['roles'].each do |role_name|
      # role = etcdctl(['role', 'get', role_name])
      instances << new(
        ensure: :present,
        name: role_name,
      )
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if (resource = resources[prov.name])
        resource.provider = prov
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present || false
  end

  def create
    etcdctl(['role', 'add', @resource['name']])
    @property_hash[:ensure] = :present
  end

  def destroy
    etcdctl(['role', 'delete', @resource['name']])
    @property_hash.clear
  end
end
