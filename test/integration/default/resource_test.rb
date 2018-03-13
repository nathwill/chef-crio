control 'pulls image' do
  describe command('podman images') do
    its('stdout') { should match 'docker.io/library/redis' }
  end
end

control 'runs container' do
  describe command('podman ps') do
    its('stdout') { should match 'redis' }
  end

  describe file('/etc/systemd/system/redis.service') do
    its('content') { should match 'podman run' }
  end

  describe service('redis') do
    it { should be_enabled }
    it { should be_running }
  end
end
