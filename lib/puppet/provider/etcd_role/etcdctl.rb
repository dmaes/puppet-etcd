# frozen_string_literal: true

require_relative('../etcdctl')

Puppet::Type.type(:etcd_role).provide(:etcdctl, parent: Puppet::Provider::Etcdctl) do
  desc 'Manages etcd roles'

  def self.instances
    instances = []
    role_list = h_etcdctl(['role', 'list'])
    return instances unless role_list.key?('roles')
    role_list['roles'].each do |role_name|
      # role = h_etcdctl(['role', 'get', role_name])
      instances << new(
        ensure: :present,
        name: role_name,
      )
    end
    instances
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
    h_etcdctl(['role', 'add', @resource[:name]])
    @property_hash[:ensure] = :present
  end

  def destroy
    h_etcdctl(['role', 'delete', @property_hash[:name]])
    @property_hash.clear
  end
end
