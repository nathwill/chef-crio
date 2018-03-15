crio_image 'nginx'

img = crio_image 'redis' do
  repo 'docker.io/library/redis'
  tag '3.2'
end

data_dir = directory '/data'
log_file = file '/var/log/redis.log'

crio_container 'redis' do
  image img.repo
  tag img.tag
  run_opts ['--net=host', "--workdir=#{data_dir.path}",
            "--volume=#{data_dir.path}:#{data_dir.path}",
            '--log-driver=json-file', "--log-opt=path=#{log_file.path}"]
  action [:create, :enable, :start]
  notifies :restart, to_s, :delayed
end
