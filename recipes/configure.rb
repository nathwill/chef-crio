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
end

file '/etc/sysconfig/crio-network' do
  content "CRIO_NETWORK_OPTIONS=#{cfg['network'].join(' ')}"
  mode '0640'
end

file '/etc/crio/crio.conf' do
  content({crio: cfg['conf']}.to_toml) unless cfg['conf'].empty?
  mode '0640'
end
