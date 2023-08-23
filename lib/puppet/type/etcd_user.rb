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

  newproperty(:roles, array_matching: :all) do
    desc 'The list of roles to grant to the users.'
  end
end
