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
    its('content') { should match '--net=host --workdir=/data' }
    its('content') { should match 'docker.io/library/redis:3.2' }
  end

  describe service('redis') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/var/log/redis.log') do
    its('content') { should match 'Redis' }
  end

  describe file('/var/run/redis.crio') do
    it { should be_file }
  end

  describe file('/data/dump.rdb') do
    it { should be_file }
  end
end
