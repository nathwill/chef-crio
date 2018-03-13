#
# Cookbook:: crio
# Recipe:: configure
#
# Copyright:: 2018, Nathan Williams <nath.e.will@gmail.com>
#

file '/etc/sysconfig/crio-storage' do
  content "CRIO_STORAGE_OPTIONS=#{node['crio']['storage'].join(' ')}"
end

file '/etc/sysconfig/crio-network' do
  content "CRIO_NETWORK_OPTIONS=#{node['crio']['network'].join(' ')}"
end
