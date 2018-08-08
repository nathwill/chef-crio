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
  only_if { platform?('centos') && node['crio']['repo'] == 'virt7-container-common' }
end

yum_repository 'upstream-crio-family' do
  description 'Copr repo for Upstream_CRIO_Family owned by baude'
  baseurl 'https://copr-be.cloud.fedoraproject.org/results/baude/Upstream_CRIO_Family/epel-7-$basearch/'
  gpgkey 'https://copr-be.cloud.fedoraproject.org/results/baude/Upstream_CRIO_Family/pubkey.gpg'
  only_if { platform?('centos') && node['crio']['repo'] == 'upstream-crio-family' }
end

package node['crio']['packages']
