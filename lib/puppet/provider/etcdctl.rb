# frozen_string_literal: true

require 'json'
require 'yaml'

# Helper class for common actions
class Puppet::Provider::Etcdctl < Puppet::Provider
  initvars

  def self.cfg_file
    file = '/etc/puppetlabs/puppet/etcdctl.yaml'
    confine exists: file
    file
  end

  commands cmd_etcdctl: '/usr/bin/etcdctl'

  confine do
    etcdctl(['endpoint', 'health'])
  end

  def self.etcdctl(args)
    cfg = YAML.load_file(cfg_file)
    cfg['env'].each do |key, value|
      ENV[key] = value
    end
    ENV['ETCDCTL_WRITE_OUT'] = 'json'
    out = cmd_etcdctl(args)
    begin
      JSON.parse(out)
    rescue JSON::ParserError
      out
    end
  end

  def etcdctl(args)
    self.class.etcdctl(args)
  end
end
