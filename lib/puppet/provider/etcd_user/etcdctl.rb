# frozen_string_literal: true

require_relative('../etcdctl')

Puppet::Type.type(:etcd_user).provide(:etcdctl, parent: Puppet::Provider::Etcdctl) do
  desc 'Manages etcd users.'

  def self.instances
    instances = []
    etcdctl(['user', 'list'])['users'].each do |user_name|
      user = etcdctl(['user', 'get', user_name])
      instances << new(
        ensure: :present,
        name: user_name,
        roles: user.key?('roles') ? user['roles'] : [],
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
    etcdctl(['user', 'add', @resource[:name], '--no-password'])
    @property_hash[:ensure] = :present
  end

  def destroy
    etcdctl(['user', 'delete', @property_hash[:name]])
    @property_hash.clear
  end

  mk_resource_methods

  def roles=(roles)
    @property_hash[:roles].each do |role|
      etcdctl(['user', 'revoke-role', @property_hash[:name], role]) unless roles.contains?(role)
    end
    roles.each do |role|
      etcdctl(['user', 'grant-role', @property_hash[:name], role]) unless @property_hash[:roles].contains?(role)
    end
    @property_hash[:roles] = roles
  end
end
