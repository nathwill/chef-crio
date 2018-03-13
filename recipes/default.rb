#
# Cookbook:: crio
# Recipe:: default
#
# Copyright:: 2018, Nathan Williams <nath.e.will@gmail.com>
#

%w( install configure manage ).each do |r|
  include_recipe "#{cookbook_name}::#{r}"
end
