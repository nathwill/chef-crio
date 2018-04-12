control 'pulls image' do
  # image download
  describe command('podman images') do
    its('stdout') { should match 'docker.io/library/busybox' }
    its('stdout') { should match 'docker.io/library/redis' }
  end
end

control 'runs container' do
  # running under podman
  describe command('podman ps --format="{{.Names}}"') do
    its('stdout') { should match 'redis' }
  end

  # defined system service
  describe file('/etc/systemd/system/redis.service') do
    # runs under podman
    its('content') { should match 'podman  run' }
    # configures run opts
    its('content') { should match '--net=host' }
    # specifies image
    its('content') { should match 'redis:3.2' }
  end

  describe file('/etc/systemd/system/redis.service.d/pull.conf') do
    its('content') { should match 'podman  pull' }
  end

  # functional
  describe service('redis') do
    it { should be_enabled }
    it { should be_running }
  end

  # captures log output
  describe file('/var/log/redis.log') do
    its('content') { should match 'Redis' }
  end

  # generates pid-file
  describe file('/run/redis.pid') do
    it { should be_file }
  end

  # host:container bind-mount
  describe file('/data/dump.rdb') do
    it { should be_file }
  end

  # uses host networking
  describe command('netstat -lptn') do
    its('stdout') { should match ':::6379' }
  end
end
