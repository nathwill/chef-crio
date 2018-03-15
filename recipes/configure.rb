#
# Cookbook:: crio
# Recipe:: configure
#
# Copyright:: 2018, Nathan Williams <nath.e.will@gmail.com>
#

cfg = node['crio']

file '/etc/sysconfig/crio-storage' do
  content "CRIO_STORAGE_OPTIONS=#{cfg['storage'].join(' ')}"
  mode '0640'
  not_if { cfg['storage'].empty? }
end

file '/etc/sysconfig/crio-network' do
  content "CRIO_NETWORK_OPTIONS=#{cfg['network'].join(' ')}"
  mode '0640'
  not_if { cfg['network'].empty? }
end

file '/etc/crio/crio.conf' do
  content({ crio: cfg['conf'] }.to_toml)
  mode '0640'
  not_if { cfg['conf'].empty? }
end
