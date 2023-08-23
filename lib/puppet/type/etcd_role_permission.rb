# frozen_string_literal: true

Puppet::Type.newtype(:etcd_role_permission) do
  @doc = <<-DOC
    @summary
      Manage an etcd role permissions
  DOC

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the role permission. Must be of `${role}:${key}` format.'
  end

  newproperty(:role) do
    desc 'The name of the role to grant to. (required)'
  end

  newproperty(:key) do
    desc 'The key to grant permission on. (required)'
  end

  newproperty(:permission) do
    desc 'The permission type, must be one of `(read|write|readwrite)`.'
  end

  newproperty(:range_end) do
    desc 'Optional range end to grant permission on. Use `etcd::prefix_range_end($key)` if you want to grant prefix.'
  end

  validate do
    raise(_('etcd_role_permission: `role` parameter is required')) if self[:role].nil?
    raise(_('etcd_role_permission: `key` parameter is required')) if self[:key].nil?
    raise(_('etcd_role_permission: `permission` parameter is required')) if self[:permission].nil? && self[:ensure] == 'present'
    raise(_('etcd_role_permission: `name` should be `$role:$key` format')) unless self[:name] == "#{self[:role]}:#{self[:key]}"
    unless ['read', 'write', 'readwrite'].include? self[:permission]
      raise(_('etcd_role_permission: `permission` should be one of (read|write|readwrite)'))
    end
  end
end
