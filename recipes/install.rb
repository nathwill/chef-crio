#
# Cookbook:: crio
# Recipe:: install
#
# Copyright:: 2018, Nathan Williams <nath.e.will@gmail.com>
#

yum_repository 'virt7-container-common' do
  description 'Container Virtualization Extras for EL'
  baseurl 'https://cbs.centos.org/repos/virt7-container-common-candidate/x86_64/os/'
  gpgcheck false
  only_if { platform?('centos') }
end

package %w(cri-o cri-tools podman)
