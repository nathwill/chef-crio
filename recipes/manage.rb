#
# Cookbook:: crio
# Recipe:: manage
#
# Copyright:: 2018, Nathan Williams <nath.e.will@gmail.com>
#

service 'crio' do
  action [:enable, :start]
end
