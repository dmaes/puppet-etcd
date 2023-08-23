# frozen_string_literal: true

require 'base64'

require_relative('../etcdctl')

Puppet::Type.type(:etcd_role_permission).provide(:etcdctl, parent: Puppet::Provider::Etcdctl) do
  desc 'Manages etcd role permissions'

  def self.parse_perm_type(perm_type)
    return 'read' if perm_type.nil? || perm_type == 0
    return 'write' if perm_type == 1
    return 'readwrite' if perm_type == 2
    nil
  end

  def self.instances
    instances = []
    etcdctl(['role', 'list'])['roles'].each do |role_name|
      role = etcdctl(['role', 'get', role_name])
      next unless role.key?('perm')
      role['perm'].each do |perm|
        key = Base64.decode64(perm['key'])
        range_end = perm.key?('range_end') ? Base64.decode64(perm['range_end']) : ''
        instances << new(
          ensure: :present,
          name: "#{role_name}:#{key}",
          role: role_name,
          key: key,
          permission: parse_perm_type(perm['permType']),
          range_end: range_end,
        )
      end
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
    self.class.grant(@resource[:role], @resource[:permission], @resource[:key], @resource[:range_end])
    @property_hash[:ensure] = :present
  end

  def destroy
    self.class.revoke(@resource[:role], @resource[:key])
    @property_hash.clear
  end

  def self.grant(role, permission, key, range_end)
    etcdctl(['role', 'grant-permission', role, permission, key, range_end])
  end

  def self.revoke(role, key)
    etcdctl(['role', 'revoke-permission', role, key])
  end

  mk_resource_methods

  def permission=(permission)
    self.class.revoke(@property_hash[:role], @property_hash[:key])
    self.class.grant(@property_hash[:role], permission, @property_hash[:key], @resource[:range_end])
  end

  def range_end=(range_end)
    self.class.revoke(@resource[:role], @resource[:key])
    self.class.grant(@resource[:role], @resource[:permission], @resource[:key], range_end)
  end
end
