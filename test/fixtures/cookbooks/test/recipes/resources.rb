
img = crio_image 'redis' do
  repo 'docker.io/library/redis'
  tag '3.2'
end

d = directory '/data'

crio_container 'redis' do
  image img.repo
  tag img.tag
  supervise true
  run_opts ["--volume=#{d.path}:#{d.path}", '--net=host',
            "--workdir=#{d.path}", '--log-driver=json-file',
            '--log-opt=path=/var/log/redis.log']
  action [:create, :enable, :start]
  notifies :restart, to_s, :delayed
end
