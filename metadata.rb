name 'crio'
maintainer 'Nathan Williams'
maintainer_email 'nath.e.will@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures crio'
long_description 'Installs/Configures crio'
version '1.3.1'
chef_version '>= 12.1' if respond_to?(:chef_version)

supports 'centos', '>= 7.0'

gem 'toml' if respond_to?(:gem)

source_url 'https://github.com/nathwill/chef-crio'
issues_url 'https://github.com/nathwill/chef-crio/issues'
