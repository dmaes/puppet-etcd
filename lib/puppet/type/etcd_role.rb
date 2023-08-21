# frozen_string_literal: true

Puppet::Type.newtype(:etcd_role) do
  @doc = <<-DOC
    @summary
      Manage an etcd role
  DOC

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the role.'
  end
end
