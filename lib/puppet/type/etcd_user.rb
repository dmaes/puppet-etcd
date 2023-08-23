# frozen_string_literal: true

Puppet::Type.newtype(:etcd_user) do
  @doc = <<-DOC
    @summary
      Manage etcd users.
      This resource does not manage user passwords, since etcd doesn't provide the necessary endpoints to do this cleanly.
      Users will be created without password (aka: only cert auth allowed), and manually configured passwords will be ignored.
  DOC

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the user.'
  end

  newproperty(:roles, array_matching: :all) do
    desc 'The list of roles to grant to the users.'
  end
end
