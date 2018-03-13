#
# Cookbook:: crio
# Recipe:: manage
#
# Copyright:: 2018, Nathan Williams <nath.e.will@gmail.com>
#

service 'crio' do
  action [:enable, :start]
  subscribes :restart, 'file[/etc/sysconfig/crio-storage]', :delayed
  subscribes :restart, 'file[/etc/sysconfig/crio-network]', :delayed
end
