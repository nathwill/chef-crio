control 'installs crio packages' do
  describe package('cri-o') do
    it { should be_installed }
  end

  describe package('podman') do
    it { should be_installed }
  end
end

control 'configures crio' do
  describe file('/etc/sysconfig/crio-storage') do
    its('content') { should match 'CRIO_STORAGE_OPTIONS=' }
  end

  describe file('/etc/sysconfig/crio-network') do
    its('content') { should match 'CRIO_NETWORK_OPTIONS=--enable-metrics' }
  end
end

control 'manages crio' do
  describe service('crio') do
    it { should be_enabled }
    it { should be_running }
  end
end
